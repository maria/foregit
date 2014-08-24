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
        puts "Checking from #{@git.branch.name} to #{repo_branch}..."
        @git.branch(@repo_branch).checkout
      end
    end

    # If a repository remote is defined, clone the repository.
    # Else create a local repository, without a remote.
    def init_project(settings)
      if settings.has_key?(:repo_remote)
        @git = Git.clone(settings[:repo_remote], :path => @repo_path)
      else
        @git = create_project(settings)
      end
      config(settings)
    end

    def create_project(settings)
      puts 'Create new repository #{@repo_path}...'
      FileUtils.mkdir(@repo_path) unless Dir.exists?(@repo_path)
      git = Git.init(@repo_path)
      puts 'Done!'
      return git
    end

    def config(settings)
      puts 'Configure Git...'
      @git.config('user.name', settings[:git_username]) if settings.has_key? :git_username
      @git.config('user.email', settings[:git_useremail]) if settings.has_key? :git_useremail
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

    def get_status(tag)
      system("cd #{@repo_path} && git diff --name-status #{tag}^ HEAD > changes")
      changes = clean(File.open("#{@repo_path}/changes").readlines)
      return changes
    end

    private

    def clean(git_statuses)
      changes = []
      git_statuses.each do |git_status|
        changes << {:type => git_status.split[0], :file => git_status.split[1]}
      end
      return changes
    end

  end
end
