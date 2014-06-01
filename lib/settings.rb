require "yaml"
require "ostruct"
require "pathname"

class Settings < OpenStruct

  def self.load_from_file(settings_path=nil)
    if settings_path.nil?
      settings_path = Pathname.new(__FILE__).join("..","..","config",
                                                  "settings.yml")
    end

    settings = YAML.load(File.read(settings_path))
    Settings.new(settings)
  end

end
