require 'apipie-bindings'

require 'foregit'

class Foreman

  class Api
    include Foregit

    attr_reader :api

    def initialize(settings)
      @settings = settings
      @api ||= ApipieBindings::API.new({
        :uri => @settings[:api_url],
        :api_version => @settings[:api_version],
        :oauth => {
          :consumer_key    => @settings[:consumer_key],
          :consumer_secret => @settings[:consumer_secret]
        },
        :timeout => @settings[:timeout],
        :headers => {
          :foreman_user => @settings[:api_user]
        }})
    end

    # Public: Download a list of resources from a Foreman instance.
    #
    # resources: a list of Foreman resource, such as :arhitectures, :hosts_groups
    #
    # Get the array of resources to be downloaded, and for each make an API call
    # to Foreman.
    # Returns a hash
    #   {:resource_name => array_of_resources_downloaded}
    def download_resources(resources=nil)

      resources = get_resources_to_download(resources)
      foreman_resources = Hash.new

      resources.each do |resource|
        resource = resource.to_sym if resource.is_a? String
        foreman_resources[resource] = @api.call(resource, :index)['results']
      end

      return foreman_resources
    end

    def upload_resources(resources)
      resources.each do |resource_name, resource_data|
        call_action(name, :create, data)
      end
    end

    def call_action(name, action, data)
        name = name.to_sym if name.is_a? String
        action = action.to_sym if action.is_a? String
        @api.call(name, action, data)
    end

    private

      # Private: Define the list of resources to be downloaded from Foreman.
      #
      # resources: a list of Foreman resources, or nil
      #
      # If no resources are given, return the default list from settings.
      # If none is define then raise an error.
      #
      # Returns resources as an Array.
     def get_resources_to_download(resources)

      if resources.nil?
        if !@settings[:resources].nil?
          resources = @settings[:resources]
        else
          raise ArgumentError, 'No list of resources to download.'
        end
      end

      if not resources.is_a? Array
        resources = Array(resources)
      end

      return resources
     end

  end

end
