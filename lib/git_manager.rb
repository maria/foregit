require 'git'

require 'foregit'

class GitManager

    def initialize
      @git = Git.open(Foregit::SETTINGS.repo_path)
    end

    def get_diff
      # get last local commit
      last_commit_sha = @git.log(1)[0].sha
      # ensure we are on the correct branch
      if @git.branch.name != Foregit::SETTINGS.repo_branch
        puts "Currently on #{@git.branch.name}, not on #{Foregit::SETTINGS.repo_branch}!"
      end
      # Get upstream changes
      @git.pull
      # Get differences between commit
      new_last_commit_sha = @git.log(1)[0].sha
      commits_diff = @git.diff(last_commit_sha, new_last_commit_sha).path('resources/')
    end

    def apply_diff(commits_diff)
      if commits_diff.size == 0
        puts 'Everything is up to date!'
      end
      # Get changes and apply them to Foreman instance
      commits_diff.stats[:files].each do |file, stats|
        puts file
      end
    end

end
