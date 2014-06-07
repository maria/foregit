require "yaml"
require "ostruct"
require "pathname"

class Settings < OpenStruct

  def self.load_from_file(settings_path=nil)
    if settings_path.nil?
      settings_path = Pathname.new(__FILE__).join("..","..","config",
                                                  "settings.yaml")
    end

    settings = Settings.new(YAML.load(File.read(settings_path)))
    settings.to_h
  end

end
