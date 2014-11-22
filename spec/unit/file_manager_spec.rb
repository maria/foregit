require 'json'

require 'spec_helper'
require 'foregit'
require 'file_manager'


describe Foregit::FileManager do

  before(:all) do
    # Define test directory path
    @repo_path = File.expand_path('../data', __FILE__)
    # Create settings
    @settings = attributes_for(:settings)
    @settings[:repo_path] = @repo_path
    # Create directory to store Foregit data
    FileUtils.mkdir(@repo_path)
    # Create FileManager object
    @manager = Foregit::FileManager.new @settings
  end

  after(:all) do
    FileUtils.rm_rf(@repo_path)
  end

  describe '#initiliaze' do

    it 'should set repo_path when is set in settings' do
      expect(@manager.repo_path).to be(@repo_path)
    end

    it 'should raise an error when no repo_path is set' do
      settings = @settings
      settings.delete(:repo_path)
      expect{ Foregit::FileManager.new settings}.to raise_error(ArgumentError)
    end

  end

  describe '#find_file' do
    context 'file path when the file is inside the given repo path' do

      it 'should return the path when we pass the full file path' do
        file = '/test'
        file_path = File.join(@repo_path, file)

        expect(Foregit::FileManager::File).to receive(:expand_path).with(file).and_return(file_path)
        expect(Foregit::FileManager::File).to receive(:fnmatch?).with(@repo_path + '*', file_path).and_return(true)
        expect(@manager).to receive(:can_read_file?).with(file_path).and_return(true)

        expect(@manager.find_file file).to match(file_path)
      end

      it 'should return the path when we pass the relative path of the file within the repo' do
        file = '../test'
        file_path = File.join(@repo_path, file)

        expect(Foregit::FileManager::File).to receive(:expand_path).with(file).and_return(file_path)
        expect(Foregit::FileManager::File).to receive(:fnmatch?).with(@repo_path + '*', file_path).and_return(true)
        expect(@manager).to receive(:can_read_file?).with(file_path).and_return(true)

        expect(@manager.find_file file).to match(file_path)
      end
    end

    context 'file path when the file is not inside the given repo' do

      it 'should return nil we pass the path of a file outside the repo' do
        file = 'test'
        file_path = File.join(@repo_path, file)

        expect(Foregit::FileManager::File).to receive(:expand_path).with(file).and_return(file_path)
        expect(Foregit::FileManager::File).to receive(:join).with(@repo_path, file).and_return(file_path)
        expect(@manager).to receive(:can_read_file?).twice.with(file_path).and_return(false)

        expect(@manager.find_file file).to be(nil)
      end
    end

  end

  describe '#dump_object_as_file' do

    context 'dumping a valid JSON in an existent file' do

      it 'should contain the resource content' do
        file = 'test.json'
        file_path = File.join(@repo_path, file)
        File.open(file_path, 'w') {}

        resource = {
          :type => 'resources',
          :name => 'all',
          :content => {:resources => [:architectures, :hosts_groups]}
        }

        @manager.dump_object_as_file(resource, file)
        expect(JSON.parse(File.read(file_path))).to match(JSON.parse(resource[:content].to_json))

      end
    end

    context 'dumping a valid JSON in an inexistent file' do

      it 'should contain the resource content after is created' do
        architectures = build(:architectures)
        resource = {
            :type => 'architectures',
            :name => architectures.name,
            :content => {:resources => [:architectures, :hosts_groups]}
        }

        @manager.dump_object_as_file(resource)
        file_path = @manager.find_file('architectures/' + architectures.name + '.json')
        expect(JSON.parse(File.read(file_path))).to match(JSON.parse(resource[:content].to_json))

      end
    end

  end

end
