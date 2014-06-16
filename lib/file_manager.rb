require 'fileutils'
require 'json'

require 'foregit'

class FileManager

  attr_reader :repo_path

  def initialize(repo_path=nil)
    if !repo_path.nil?
      @repo_path = repo_path
    elsif repo_path.nil? and !Foregit::SETTINGS.repo_path.nil?
      @repo_path = Foregit::SETTINGS.repo_path
    else
      raise ArgumentError, 'No path for the repository was given!'
    end
  end

  def repo_path
    @repo_path
  end

  def find_file(file)
    relative_path = File.expand_path(file)

    if can_read_file?(relative_path) && File.fnmatch?(@repo_path + '*', relative_path)
      return relative_path

    else
      full_path = File.join(@repo_path, file)
      if can_read_file?(full_path)
        return full_path
      end
    end
  end

  def dump_object_as_file(resource, file=nil)
    if !file.nil?
      file_path = find_file(file)

    elsif file.nil?
      # If we don't have a file, it means it's a new configuration and a new
      # file has to be created beforehand.
      dir_path = ensure_directory(resource[:type])
      file_path = ensure_file(dir_path, resource[:name])
    end

    opened_file = File.open(file_path, 'w')
    object = opened_file.write(JSON.dump(resource[:content]))
    opened_file.close
  end

  def ensure_directory(directory)
    dir_path = File.join(@repo_path, directory)
    if !Dir.exists?(dir_path)
      FileUtils.mkdir(dir_path)
    end
    return dir_path
  end

  def ensure_file(directory, file, extension='.json')
    file_path = File.join(directory, file + extension)
    if !File.exists?(file_path)
      FileUtils.touch(file_path)
    end
    return file_path
  end

  def can_read_file?(file)
    File.exists?(file) && File.readable?(file)
  end

end
