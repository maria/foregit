require 'foregit'

class FileManager

  attr_reader :repo_path

  def initialize(repo_path=nil)
    if repo_path.nil? and !Foregit::SETTINGS[:repo_path].nil?
      @repo_path = Foregit::SETTINGS[:repo_path]
    elsif !repo_path.nil?
      @repo_path = repo_path
    else
      raise ArgumentError, 'No path for the repository was given!'
    end
  end

  def repo_path
    @repo_path
  end

  def find_file(file)
    full_path = File.join(@repo_path, file)
    relative_path = File.expand_path( file )

    if can_read_file?(relative_path) and File.fnmatch?(@repo_path + '*', relative_path)
      return relative_path

    elsif can_read_file?(full_path)
      return full_path
    else
      nil
    end
  end

  def can_read_file?(file)
    File.exists?(file) && File.readable?(file)
  end

end
