#!/usr/bin/ruby
require 'optparse'

require 'talk_commands'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: command.rb [options]"

  opts.on("-s", "--sync", "Sync resources") do |s|
    options[:sync] = s
  end
end.parse!


if options.has_key? :sync
    puts "Sync Foreman resources..."
    TalkCommands.pull
    puts "Done!"
end
