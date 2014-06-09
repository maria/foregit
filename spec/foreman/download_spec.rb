# Test the API binding to Foreman instance
require 'json'

require 'rspec'

require_relative '../../lib/foregit'
require_relative '../../lib/foreman/api'
require_relative '../../lib/foreman/download'

describe Foreman::Download do

  before (:each) do
    # Ensure we set in the settings file the expected resource
    Foregit::SETTINGS[:resources] = :architectures

    # Mock Foreman API response for resources
    @api = Foreman::Api.api
    allow(@api).to receive(:call).and_return(build(:resources).to_json)

    @binding = Foreman::Download.new
  end

  describe '#download_resources' do

    context 'download resources defined in settings file' do
      it 'should return a hash with :architectures' do
        downloaded_resources = @binding.download_resources
        expect(downloaded_resources.is_a? Hash).to be(true)
        expect(downloaded_resources.has_key? :architectures).to be(true)
      end
    end

    context 'download resources passed as arguments' do
      it 'should return a hash with :hosts_groups' do
        downloaded_resources = @binding.download_resources(:hosts_groups)
        expect(downloaded_resources.is_a? Hash).to be(true)
        expect(downloaded_resources.has_key? :hosts_groups).to be(true)
      end
    end

    context 'download resources raises error when no resource is set' do
      it 'should raise error' do
        # Ensure no resources are set to be downloaded from Foreman
        Foregit::SETTINGS.delete(:resources)
        expect{@binding.download_resources}.to raise_error
      end
    end

  end

end
