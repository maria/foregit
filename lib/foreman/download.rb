require_relative '../foregit'
require_relative 'api'

class Foreman

  class Download

    def initialize
      @api ||= Foreman::Api.api
    end

    def download_resources(resources=nil)
      resources = get_resources_to_download(resources)
      foreman_resources = []

      resources.each do |resource|
        foreman_resources << @api.call(resource, :index)['results']
      end
      return foreman_resources
    end

    private

     def get_resources_to_download(resources)
      # If no resources are given, return the default list.
      # Else ensure the resources is a list.

      if resources.nil?
        resources = Foregit::SETTINGS[:resources]
      end

      if not resources.is_a? Array
        resources = Array(resources)
      end

      return resources
     end

  end

end

