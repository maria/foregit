require 'spec_helper'

require 'foregit'
require 'file_manager'


describe FileManager do

  describe '#initiliaze' do

    it 'should set repo_path when is set in settings' do
      repo_path = '/home/test/repo/path'
      Foregit::SETTINGS[:repo_path] = repo_path
      manager = FileManager.new
      expect(manager.repo_path).to be(repo_path)
    end

    it 'should set repo_path when is given' do
      repo_path = '/home/test/repo/path'
      Foregit::SETTINGS[:repo_path] = '/home/test/false/repo/path'
      manager = FileManager.new repo_path
      expect(manager.repo_path).to be(repo_path)
    end

    it 'should raise an error when no repo_path is set' do
      Foregit::SETTINGS[:repo_path] = nil
      expect{FileManager.new}.to raise_error(ArgumentError)
    end

  end

  describe '#find_file' do
    context 'file path when the file is inside the given repo path' do

      repo_path = '/home/test/repo/path'
      manager = FileManager.new(repo_path)

      it 'should return the path when we pass the full file path' do
        file = '/test'
        file_path = repo_path + file

        expect(FileManager::File).to receive(:expand_path).with(file).and_return(file_path)
        expect(FileManager::File).to receive(:fnmatch?).with(repo_path + '*', file_path).and_return(true)
        expect(manager).to receive(:can_read_file?).with(file_path).and_return(true)

        expect(manager.find_file file).to match(file_path)
      end

      it 'should return the path when we pass the relative path of the file within the repo' do
        file = '../test'
        file_path = '/home/test/repo/test'

        expect(FileManager::File).to receive(:expand_path).with(file).and_return(file_path)
        expect(FileManager::File).to receive(:fnmatch?).with(repo_path + '*', file_path).and_return(true)
        expect(manager).to receive(:can_read_file?).with(file_path).and_return(true)

        expect(manager.find_file file).to match(file_path)
      end
    end

    context 'file path when the file is not inside the given repo' do
      repo_path = '/home/test/repo/path'
      manager = FileManager.new(repo_path)

      it 'should return nil we pass the path of a file outside the repo' do
        file = 'test'
        file_path = '/home/test/repo/path/test'

        expect(FileManager::File).to receive(:expand_path).with(file).and_return(file_path)
        expect(FileManager::File).to receive(:join).with(repo_path, file).and_return(file_path)
        expect(manager).to receive(:can_read_file?).twice.with(file_path).and_return(false)

        expect(manager.find_file file).to be(nil)
      end
    end

  end

end
