require 'json'

require 'spec_helper'
require 'foregit'
require 'file_manager'


describe FileManager do

  before(:all) do
    FileUtils.mkdir(File.expand_path('../data', __FILE__))
  end

  after(:all) do
    FileUtils.rm_rf(File.expand_path('../data', __FILE__))
  end

  describe '#initiliaze' do
    let(:repo_path) { File.expand_path('../data', __FILE__) }

    it 'should set repo_path when is set in settings' do
      Foregit::SETTINGS.repo_path = repo_path
      manager = FileManager.new
      expect(manager.repo_path).to be(repo_path)
    end

    it 'should set repo_path when is given' do
      Foregit::SETTINGS.repo_path = repo_path
      manager = FileManager.new repo_path
      expect(manager.repo_path).to be(repo_path)
    end

    it 'should raise an error when no repo_path is set' do
      Foregit::SETTINGS.repo_path = nil
      expect{ FileManager.new }.to raise_error(ArgumentError)
    end

  end

  describe '#find_file' do
    context 'file path when the file is inside the given repo path' do
      let(:repo_path) { File.expand_path('../data', __FILE__) }
      let(:manager) { FileManager.new repo_path }

      it 'should return the path when we pass the full file path' do
        file = '/test'
        file_path = File.join(repo_path, file)

        expect(FileManager::File).to receive(:expand_path).with(file).and_return(file_path)
        expect(FileManager::File).to receive(:fnmatch?).with(repo_path + '*', file_path).and_return(true)
        expect(manager).to receive(:can_read_file?).with(file_path).and_return(true)

        expect(manager.find_file file).to match(file_path)
      end

      it 'should return the path when we pass the relative path of the file within the repo' do
        file = '../test'
        file_path = File.join(repo_path, file)

        expect(FileManager::File).to receive(:expand_path).with(file).and_return(file_path)
        expect(FileManager::File).to receive(:fnmatch?).with(repo_path + '*', file_path).and_return(true)
        expect(manager).to receive(:can_read_file?).with(file_path).and_return(true)

        expect(manager.find_file file).to match(file_path)
      end
    end

    context 'file path when the file is not inside the given repo' do
      let(:repo_path) { File.expand_path('../data', __FILE__) }
      let(:manager) { FileManager.new repo_path }

      it 'should return nil we pass the path of a file outside the repo' do
        file = 'test'
        file_path = File.join(repo_path, file)

        expect(FileManager::File).to receive(:expand_path).with(file).and_return(file_path)
        expect(FileManager::File).to receive(:join).with(repo_path, file).and_return(file_path)
        expect(manager).to receive(:can_read_file?).twice.with(file_path).and_return(false)

        expect(manager.find_file file).to be(nil)
      end
    end

  end

  describe '#dump_object_as_file' do

    context 'dumping a valid JSON in an existent file' do
      let(:repo_path) { File.expand_path('../data', __FILE__) }
      let(:manager) { FileManager.new repo_path }

      it 'the file should contain the resource content' do
        file = 'test.json'
        file_path = File.join(repo_path, file)
        File.open(file_path, 'w') {}

        resource = {
          :type => 'resources',
          :name => 'all',
          :content => {:resources => [:architectures, :hosts_groups]}
        }

        manager.dump_object_as_file(resource, file)
        expect(File.read(file_path)).to match(resource[:content].to_json)

      end
    end

    context 'dumping a valid JSON in an inexistent file' do
      let(:repo_path) { File.expand_path('../data', __FILE__) }
      let(:manager) { FileManager.new repo_path }

      it 'the file should contain the resource content after is created' do
        architectures = build(:architectures)
        resource = {
            :type => 'architectures',
            :name => architectures.name,
            :content => {:resources => [:architectures, :hosts_groups]}
        }

        manager.dump_object_as_file(resource)
        file_path = manager.find_file('architectures/' + architectures.name + '.json')

        expect(File.read(file_path)).to match(resource[:content].to_json)

      end
    end

  end

end
