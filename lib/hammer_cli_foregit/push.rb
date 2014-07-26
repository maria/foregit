require 'hammer_cli_foregit/abstract_command'

module HammerCLIForegit

  class Push < HammerCLIForegit::AbstractCommand

    def execute
      super
      puts 'Upload changes to Foreman...'
      @talk.push
      puts 'Done!'
      HammerCLI::EX_OK
    end
  end
end

HammerCLI::MainCommand.subcommand 'push',
  'Upload changes from the Git repository to the Foreman instance',
  HammerCLIForegit::Push
