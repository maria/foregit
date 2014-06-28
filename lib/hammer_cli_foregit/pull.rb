require 'sync'

require 'hammer_cli'

# it's a good practice to nest commands into modules
module HammerCLIPull

  # hammer commands must be descendants of AbstractCommand
  class PullCommand < HammerCLI::AbstractCommand

    # execute is the heart of the command
    def execute
        puts "Sync Foreman resources..."
        sync = Sync.new
        sync.pull
        puts "Done!"
    end
  end

  # now plug your command into the hammer's main command
  HammerCLI::MainCommand.subcommand
    'pull',                  # command's name
    "Pull Foreman settings to Git repository",   # description
    HammerCLIPull::PullCommand  # the class
end
