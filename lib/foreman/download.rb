require 'foregit'
require 'foreman/api'

class Foreman

  class Download

    attr_reader :api

    def api
      @api ||= Foreman::Api.api
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
        foreman_resources[resource] = @api.call(resource, :index)['results']
      end

      return foreman_resources
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
        if !Foregit::SETTINGS.resources.nil?
          resources = Foregit::SETTINGS.resources
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

