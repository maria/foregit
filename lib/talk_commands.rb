=begin
sync command
    - get settings
    - download(settings[resources])
    - file manager
=end

require 'file_manager'
require 'foreman/download'

class TalkCommands

  def self.pull(foreman_resources=nil)
    download_manager = Foreman::Download.new
    resources = download_manager.download_resources(foreman_resources)
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

  def self.push
  end
end
