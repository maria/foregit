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
      commits_diff = @git.diff(last_commit_sha, new_last_commit_sha)
    end

    def apply_diff(commits_diff)
      if commits_diff.size == 0
        puts 'Everything is up to date!'
      end
      # Get changes and apply them to Foreman instance
      commits_diff.stats[:files].each do |file, stats|
        puts "Update/add Foreman resource #{file}..."
        data = file_manager.load_file_as_json(file)
        puts data
        puts "Done!"
      end
    end

end
