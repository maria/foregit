require 'git'

require 'foregit'


class GitManager

    def initialize(settings)
      @git = Git.open(settings[:repo_path])
      # Check we are on the correct branch
      repo_branch = settings[:repo_branch]
      if @git.branch.name != repo_branch
        puts "Currently on #{@git.branch.name}, not on #{repo_branch}!"
      end
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
