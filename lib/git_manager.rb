require 'fileutils'
require 'git'

require 'foregit'

module Foregit

  class GitManager

    attr_reader :git

    # Ensure the repository exists on the localhost. Either clone or create it.
    # Configure Git settings and ensure the workspace is on the expected branch.
    def initialize(settings)
      @repo_path = settings[:repo_path]
      @repo_branch = settings[:repo_branch]

      # Create directory and repository if it's not on the localhost
      init_project(settings) if !Dir.exists?(@repo_path)

      @git = Git.open(@repo_path)
      # Check we are on the correct branch
      if @git.branch.name != @repo_branch
        puts "Checking from #{@git.branch.name} to #{@repo_branch}..."
        @git.branch(@repo_branch).checkout
      end
    end

    # If a repository remote is defined, clone the repository.
    # Else create a local repository, without a remote.
    def init_project(settings)
      if settings.has_key? :repo_remote
        @git = Git.clone(settings[:repo_remote], @repo_path)
      else
        @git = create_project
      end
        config(settings)
    end

    def create_project
      puts 'Create local repository #{@repo_path}...'
      FileUtils.mkdir(@repo_path) unless Dir.exists?(@repo_path)
      git = Git.init(@repo_path)
      puts 'Done!'
      return git
    end

    def config(settings)
      puts 'Configure Git...'
      @git.config('user.name', settings[:git_username]) if settings.has_key? :git_username
      @git.config('user.email', settings[:git_useremail]) if settings.has_key? :git_useremail
      puts "Done."
    end

    def commit(message='Sync')
      @git.add
      begin
        @git.commit(message)
      rescue StandardError
        puts 'Nothing to commit.'
        return
      end
      puts "Commited with message: #{message}."
    end

    def get_remote_diff
      # get last local commit
      last_commit_sha = @git.log(1)[0].sha
      @git.pull
      # Get differences between commit
      new_last_commit_sha = @git.log(1)[0].sha
      commits_diff = @git.diff(new_last_commit_sha, last_commit_sha)

      if commits_diff.size == 0
        puts 'Everything is up to date!'
      end
      commits_diff.stats[:files]
    end

    def get_status
      @git.add
      system("cd #{@repo_path} && git diff --name-status ^HEAD > /tmp/changes")
      changes = clean(File.open('/tmp/changes').readlines)
      return changes
    end

    private

    def clean(statuses)
      changes = []
      statuses.each do |status|
        next if status.strip.end_with? 'changes'
        changes << {:type => status.split[0], :file => status.split[1]}
      end
      return changes
    end

  end
end
