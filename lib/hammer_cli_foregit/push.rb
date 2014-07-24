require 'hammer_cli_foregit/abstract_command'

module HammerCLIForegit

  class Push < HammerCLIForegit::AbstractCommand

    def execute
      super
      puts 'Upload changes to Foreman...'
      @git_manager.commit("Commit existent changes before push.")
      @file_manager.get_repo_json_files.each do |file|
        data = @file_manager.load_file_as_json(file)
        @binding.call_action(file, :create, data)
      end
      puts 'Done!'
      HammerCLI::EX_OK
    end
  end
end

HammerCLI::MainCommand.subcommand 'push',
  'Upload changes from the Git repository to the Foreman instance',
  HammerCLIForegit::Push
