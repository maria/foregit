require 'hammer_cli_foregit/abstract_command'

module HammerCLIForegit

  class Pull < HammerCLIForegit::AbstractCommand

    option ['-r', '--resources'], 'RESOURCES', 'A list of Foreman API resources',
      :format => HammerCLI::Options::Normalizers::List.new

    def execute
      super
      puts "Sync from Foreman #{option_resources || 'all'} resources to Git repository..."
      @talk.pull option_resources
      @git_manager.commit("Sync #{option_resources || 'all'} resources.")
      puts 'Done!'
      HammerCLI::EX_OK
    end
  end
end

HammerCLI::MainCommand.subcommand 'pull',
  'Sync resources from Foreman to Git repository',
  HammerCLIForegit::Pull
