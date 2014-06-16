require 'rspec'
require 'factory_girl'

require 'models'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.find_definitions
