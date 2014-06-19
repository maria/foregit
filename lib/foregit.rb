module Foregit

  require 'settings'
  require 'file_manager'
  require 'sync'
  require 'command'

  require 'foreman/api'
  require 'foreman/download'

  SETTINGS = Settings.load_from_file

end
