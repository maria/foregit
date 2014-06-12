require 'apipie-bindings'

require 'foregit'

class Foreman

  class Api
    include Foregit

    # Public class method: Create a new API conenction to Foreman.
    def self.api
      @api ||= ApipieBindings::API.new({
        :uri => Foregit::SETTINGS[:api_url],
        :api_version => Foregit::SETTINGS[:api_version],
        :oauth => {
          :consumer_key    => Foregit::SETTINGS[:consumer_key],
          :consumer_secret => Foregit::SETTINGS[:consumer_secret]
        },
        :timeout => Foregit::SETTINGS[:timeout],
        :headers => {
          :foreman_user => Foregit::SETTINGS[:api_user]
        }})
    end

  end

end
