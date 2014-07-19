require 'git'

require 'foregit'


class GitManager

    def initialize(file_manager, settings)
      @repo_path = settings[:repo_path]
      @repo_branch = settings[:repo_branch]

      # Create directory and repository if it's not on the localhost
      init_project(file_manager, settings) if !file_manager.can_read_directory(@repo_path)
      @git = Git.open(@repo_path)

      # Check we are on the correct branch
      if @git.branch.name != @repo_branch
        puts "Checking from #{@git.branch.name} to #{repo_branch}..."
        @git.branch(@repo_branch).checkout
      end
    end

    def init_project(settings)
      if settings.has_key?(:git_username) && settings.has_key?(:git_useremail)
        puts "Configure Git..."
        git.config('user.name', settings[:git_username)
        git.config('user.email', settings[:git_useremail])
      end

      puts "Create new repository #{@repo_path}..."
      file_manager.ensure_directory(@repo_path)
      git = Git.init(@repo_path)

      puts "Add remote #{settings[:repo_remote]}..."
      git.add_remote('origin', settings[:repo_remote])

      puts "Fetch main #{@repo_branch} branch and checkout on it..."
      git.fetch(@repo_branch)
      git.branch(@repo_branch).checkout

      puts 'Done!'
    end

    def commit(message='Sync')
      @git.add
      @git.commit(message)
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
