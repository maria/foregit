require 'hammer_cli_foregit/abstract_command'

module HammerCLIForegit

  class Push < HammerCLIForegit::AbstractCommand

    option ['-r', '--resources'], 'RESOURCES', 'A list of Foreman API resources',
      :format => HammerCLI::Options::Normalizers::List.new

    def execute
      super
      puts "Syncing from Git repository #{option_resources || 'all'} resources to Foreman..."
      @talk.push option_resources
      puts 'Done!'
      HammerCLI::EX_OK
    end
  end
end

HammerCLI::MainCommand.subcommand 'push',
  'Sync resources from Git repository to Foreman.',
  HammerCLIForegit::Push
