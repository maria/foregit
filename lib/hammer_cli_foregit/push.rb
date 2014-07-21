require 'hammer_cli_foregit/abstract_command'

module HammerCLIForegit

  class Push < HammerCLIForegit::AbstractCommand

    def execute
      puts 'Upload changes to Foreman...'
      changes = @git_manager.get_diff
      changes.each do |file, stats|
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
