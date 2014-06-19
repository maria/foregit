=begin
sync command
    - get settings
    - download(settings[resources])
    - file manager
=end

require 'foregit'
require 'file_manager'
require 'foreman/api'
require 'foreman/download'

class Sync

  def initialize
    @api = Foreman::Api.api
  end

  def sync_foreman_to_git
    download_manager = Foreman::Download.new(@api)
    resources = download_manager.download_resources
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
end
