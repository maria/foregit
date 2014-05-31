require 'apipie-bindings'

class API

  def initialize
    @api ||= ApipieBindings::API.new({
      :uri => Settings[:api_url],
      :api_version => Settings[:api_version],
      :oauth => {
        :consumer_key    => Settings[:consumer_key],
        :consumer_secret => Settings[:consumer_secret]
      },
      :timeout => Settings[:timeout],
      :headers => {
        :foreman_user => Settings[:api_user]
      }})
  end

end
