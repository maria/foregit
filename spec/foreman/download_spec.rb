# Test the API binding to Foreman instance
#ec'
require 'json'
require 'rspec'

require_relative '../../lib/foreman/api'
require_relative '../../lib/foreman/download'

describe Foreman::Download do

  before (:each) do
    @api = Foreman::Api.api
    allow(@api).to receive(:call).and_return(build(:resources).to_json)

    @binding = Foreman::Download.new
    @downloaded_resources = @binding.download_resources
  end

  describe '#download_resources' do
    context 'download resources defined in settings file' do
      it 'should return a hash with :architectures' do
        expect(@downloaded_resources.is_a? Hash).to be(true)
      end
    end
  end

end
