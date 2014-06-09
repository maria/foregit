# Test the API binding to Foreman instance
#
require 'rspec'

require_relative '../../lib/foregit'
require_relative '../../lib/settings'
require_relative '../../lib/foreman/download'

describe Foreman::Download do

  before (:each) do
    @binding = Foreman::Download.new
    @downloaded_resources = @binding.download_resources
  end

  describe '#download_resources' do
    context 'download resources defined in settings file' do
        subject(:downloaded_resources) {@downloaded_resources}
            it 'should return a hash with :architectures' do
                expect(downloaded_resources.is_a? Hash).to be(true)
            end
    end
  end

end
