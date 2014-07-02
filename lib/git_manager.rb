require 'git'

require 'foregit'
require 'file_manager'

class GitManager

    def initialize
      @file_manager = FileManager.new(Foregit::SETTINGS.repo_path)
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
      commits_diff = @git.diff(new_last_commit_sha, last_commit_sha)

      if commits_diff.size == 0
        puts 'Everything is up to date!'
      end
      commits_diff.stats[:files]
    end

end
