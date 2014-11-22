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
                      :name => "#{resource_content["id"].to_s}_#{resource_content["name"].to_s}",
                      :content => resource_content
                    }

          @file_manager.dump_object_as_file(resource)
        end
      end
    end

    # Get all the files from the Git repo and create/update the Foreman resources
    def push(foreman_resources=nil)
      changes = @git_manager.get_status

      if !foreman_resources.nil?
        changes.each do |change|
          if not (foreman_resources.any? { |foreman_resource| change.include?(foreman_resource) })
            changes.delete(change)
          end
        end
      end

      if changes.empty?
        puts "No changes to push to Foreman."
        return
      end

      puts "Syncing changes to Foreman..."
      puts changes
      changes.each do |change|
        resource_action = get_action_based_on_change(change[:type])
        resource_type = change[:file].split('/')[0]

        if resource_action == :destroy
          data = {:id => change[:file].split('/')[1].split("_")[0]}
        else
          data = @file_manager.load_file_as_json(change[:file])
        end

        begin
          puts("#{resource_action.capitalize} #{resource_type} with #{data}...")
          @binding.call_action(resource_type, resource_action, data)
        rescue Exception => e
          puts "Error while calling action to Foreman: #{e}."
          return
        end
      end

      puts "Changes were synced."
      tag = Time.now.to_i.to_s
      @git_manager.commit("Commit existent changes. Tag: #{tag}")
      @git_manager.git.add_tag(tag)
      puts("Tagged repository with #{tag}.")

    end

    private
    def get_action_based_on_change(type)
      if type == 'D'
        return :destroy
      elsif type == 'A'
        return :create
      elsif type == 'M'
        return :update
      end
    end

  end
end
