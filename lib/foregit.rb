module Foregit

  require 'settings'
  require 'file_manager'
  require 'talk_commands'

  require 'foreman/api'
  require 'foreman/download'

  SETTINGS = Settings.load_from_file

end
