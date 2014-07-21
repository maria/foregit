require 'fileutils'
require 'git'

require 'foregit'

class GitManager

    # Ensure the repository exists on the localhost. Either clone or create it.
    # Configure Git settings and ensure the workspace is on the expected branch.
    def initialize(file_manager, settings)
      @repo_path = settings[:repo_path]
      @repo_branch = settings[:repo_branch]

      # Create directory and repository if it's not on the localhost
      init_project(settings) if !file_manager.can_read_directory(@repo_path)
      # Init repo and config git.
      @git = Git.open(@repo_path)
      config_git(settings)
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
        Git.clone(settings[:repo_remote], :path => @repo_path)
      else
        create_new_repo(settings)
      end
    end

    def create_new_repo(settings)
      puts 'Create new repository #{@repo_path}...'
      FileUtils.mkdir(@repo_path) unless Dir.exists?(@repo_path)
      git = Git.init(@repo_path)
      puts 'Done!'
    end

    def config_git(settings)
      puts 'Configure Git...'
      @git.config('user.name', settings[:git_username]) if settings.has_key? :git_username
      @git.config('user.email', settings[:git_useremail]) if settings.has_key? :git_useremail
    end

    def commit(message='Sync')
      @git.add
      @git.commit(message)
      puts "Commited with message: #{message}."
    end

    def get_diff
      # get last local commit
      last_commit_sha = @git.log(1)[0].sha
      # Get upstream changes
      @git.pull
      # Get differences between commit
      new_last_commit_sha = @git.log(1)[0].sha
      commits_diff = @git.diff(new_last_commit_sha, last_commit_sha)

      if commits_diff.size == 0
        puts 'Everything is up to date!'
      end
      commits_diff.stats[:files]
    end

end
