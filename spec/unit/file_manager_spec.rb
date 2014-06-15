require 'spec_helper'

require 'file_manager'


describe FileManager do

  before (:each) do
  end

  describe '#initiliaze' do
    it 'should set repo_path when is set in settings' do
    end

    it 'should set repo_path when is given' do
    end

    it 'should raise an error when no repo_path is set' do
    end

  end

  describe '#find_file' do
    context 'file path when the file is inside the given repo path' do

      it 'should return the path when we pass the full file path' do
      end

      it 'should return the path when we pass the relative path of the file within the repo' do
      end
    end

    context 'file path when the file is not inside the given repo' do

      it 'should return nil we pass the path of a file outside the repo' do
      end
    end

  end

end
