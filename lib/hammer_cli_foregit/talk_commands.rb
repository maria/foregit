=begin
sync command
    - get settings
    - download(settings[resources])
    - file manager
=end

require 'file_manager'
require 'git_manager'
require 'foreman/api'

class TalkCommands

  attr_reader :binding

  def initialize
    @binding = Foreman::Api.new
  end

  # Download resources from Foreman and save them as files in the Git repo
  def pull(foreman_resources=nil)
    resources = @binding.download_resources(foreman_resources)
    file_manager = FileManager.new

    resources.each do |resource_type, resources_content|
      resources_content.each do |resource_content|

        resource = {:type => resource_type.to_s,
                    :name => resource_content["name"].to_s,
                    :content => resource_content
                  }

        file_manager.dump_object_as_file(resource)
      end
    end
  end

  # Get all the files from the Git repo and create/update the Foreman resources
  def push
    git_manager = GitManager.new
    changes = git_manager.get_diff

    changes.each do |file, stats|
      data = file_manager.load_file_as_json(file)
      @binding.call_action(file, :create, data)
    end
  end
end
