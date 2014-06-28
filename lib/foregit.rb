module Foregit

  require 'settings'
  require 'file_manager'
  require 'sync'
  require 'command'

  require 'foreman/api'
  require 'foreman/download'

  require 'hammer_cli_foregit/pull'

  SETTINGS = Settings.load_from_file

end
