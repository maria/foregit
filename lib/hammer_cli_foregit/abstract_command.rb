require 'hammer_cli'

require 'file_manager'
require 'foreman/api'
require 'git_manager'
require 'talk_commands'

module HammerCLIForegit

  class AbstractCommand < HammerCLI::AbstractCommand

    def execute
      @settings = HammerCLI::Settings.get('foregit')
      @git_manager = GitManager.new (@settings)
      @talk = TalkCommands.new(@settings)
      @file_manager = FileManager.new(@settings)
      @binding = Foreman::Api.new(@settings)
    end

  end
end
