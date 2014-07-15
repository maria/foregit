module Foregit

  require 'settings'
  require 'file_manager'
  require 'git_manager'
  require 'talk_commands'

  require 'foreman/api'

  SETTINGS = Settings.load_from_file

end
