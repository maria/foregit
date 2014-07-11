require 'spec_helper'
require 'foregit'
require 'talk_commands'


describe TalkCommands do

  before(:all) do
    FileUtils.mkdir(File.expand_path('../data', __FILE__))
  end

  after(:all) do
    FileUtils.rm_rf(File.expand_path('../data', __FILE__))
  end

  describe "#pull" do
  end

  describe "#push" do
  end

end
