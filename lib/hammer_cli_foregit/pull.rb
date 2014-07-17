require 'hammer_cli'

module HammerCLIForegit

  class Pull < HammerCLI::AbstractCommand

    def execute
      print_message "Hello World!"
    end

  end

end

HammerCLI::MainCommand.subcommand 'pull', 'Download the Foreman resources and save them as files in the Git repo', HammerCLIForegit::Pull
