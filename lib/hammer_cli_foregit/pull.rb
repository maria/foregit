require 'hammer_cli_foregit/abstract_command'

module HammerCLIForegit

  class Pull < HammerCLIForegit::AbstractCommand

    option ['-r', '--resources'], 'RESOURCES', 'A list of resources to pull and save',
      :format => HammerCLI::Options::Normalizers::List.new

    def execute
      super
      puts "Syncing Foreman #{option_resources}..."
      @talk.pull option_resources
      @git_manager.commit("Sync #{option_resources || 'all'} resources")
      puts 'Done!'
      HammerCLI::EX_OK
    end
  end
end

HammerCLI::MainCommand.subcommand 'pull',
  'Download the Foreman resources and save them as files in the Git repo',
  HammerCLIForegit::Pull
