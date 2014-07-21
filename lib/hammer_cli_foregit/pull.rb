require 'hammer_cli'

require 'git_manager'
require 'talk_commands'

module HammerCLIForegit

  class Pull < HammerCLI::AbstractCommand

    option ['-r', '--resources'], 'RESOURCES', 'A list of resources to pull and save',
      :format => HammerCLI::Options::Normalizers::List.new

    def execute
      settings = HammerCLI::Settings.get('foregit')
      git = GitManager.new (settings)
      talk = TalkCommands.new(settings)
      puts "Syncing Foreman #{option_resources}..."
      talk.pull option_resources
      git.commit("Sync #{option_resources || 'all'} resources")
      puts 'Done!'
      HammerCLI::EX_OK
    end

  end

end

HammerCLI::MainCommand.subcommand 'pull',
  'Download the Foreman resources and save them as files in the Git repo',
  HammerCLIForegit::Pull
