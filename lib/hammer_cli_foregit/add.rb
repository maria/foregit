require 'hammer_cli_foregit/abstract_command'

module HammerCLIForegit

  class Add < HammerCLIForegit::AbstractCommand

    option ['-r', '--resource'], 'RESOURCE', 'The Foreman resource type',
      :format => String
    option ['-f', '--file'], 'FILE', 'A JSON or YAML file to define resource attributes',
      :format => HammerCLI::Options::Normalizers::JSONInput.new
    option ['-a', '--attributes'], 'ATTRIBUTES', 'A string of resource attributes described as key=value pairs, ex: -a "name=i382,hosts=[]"',
      :format => HammerCLI::Options::Normalizers::KeyValueList.new

    validate_options do
      option(:option_resource).required
      any(:option_file, :option_attributes).required
    end

    def execute
      super
      puts "Creating JSON representation of #{option_resource} resource in Git repo..."
      @talk.add option_resource, option_file || option_attributes
      puts 'Done!'
      HammerCLI::EX_OK
    end
  end

end

HammerCLI::MainCommand.subcommand 'add',
  'Create a new JSON file in the Git repository for a specific resource, where its attributes are set from a file or key=value pairs',
  HammerCLIForegit::Add
