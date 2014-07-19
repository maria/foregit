require 'hammer_cli'

require 'talk_commands'

module HammerCLIForegit

  class Pull < HammerCLI::AbstractCommand

    option ['-r', '--resources'], 'RESOURCES', 'A list of resources to pull and save',
      :format => HammerCLI::Options::Normalizers::List.new

    def execute
      talk = TalkCommands.new
      talk.pull option_resources
      HammerCLI::EX_OK
    end

  end

end

HammerCLI::MainCommand.subcommand 'pull', 'Download the Foreman resources and save them as files in the Git repo', HammerCLIForegit::Pull
