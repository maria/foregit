=begin
sync command
    - get settings
    - download(settings[resources])
    - file manager
=end

require 'file_manager'
require 'git_manager'
require 'foreman/api'

module Foregit

  class TalkCommands

    attr_reader :binding

    def initialize(settings, binding=nil, file_manager=nil, git_manager=nil)
      @binding = binding || Foreman::Api.new(settings)
      @file_manager = file_manager || FileManager.new(settings)
      @git_manager = git_manager || GitManager.new(settings)
    end

    # Download resources from Foreman and save them as files in the Git repo
    def pull(foreman_resources=nil)
      resources = @binding.download_resources(foreman_resources)


      resources.each do |resource_type, resources_content|
        resources_content.each do |resource_content|

          resource = {:type => resource_type.to_s,
                      :name => resource_content["name"].to_s,
                      :content => resource_content
                    }

          @file_manager.dump_object_as_file(resource)
        end
      end
    end

    # Get all the files from the Git repo and create/update the Foreman resources
    def push
      @git_manager.commit("Commit existent changes before push.")

      @file_manager.get_repo_directories.each do |dir|
        dir_files = @file_manager.get_dir_json_files(dir)
        load_files_and_create_resources(dir, dir_files) if !dir_files.empty?
      end
    end

    def load_files_and_create_resources(resource_type, resources)
      resources.each do |resource|
        data = @file_manager.load_file_as_json(File.join(resource_type, resource))
        @binding.call_action(resource_type, :create, data)
      end
    end

  end
end
