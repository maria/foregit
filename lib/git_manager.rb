require 'git'

require 'foregit'

class GitManager

    def initialize
      repo_path = Foregit::SETTINGS.repo_path
      @git = Git.open(repo_path)
    end

    def diff:
      if !@git.status.untracked.empty?
        @git.status.untracked.each do |file|
            file_name = file[:name]
        end
      end
    end
end
