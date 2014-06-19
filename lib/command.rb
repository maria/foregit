#!/usr/bin/ruby
require 'optparse'

require 'sync'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: command.rb [options]"

  opts.on("-s", "--sync", "Sync resources") do |s|
    options[:sync] = s
  end
end.parse!


if options.has_key? :sync
    puts "Sync Foreman resources..."
    sync = Sync.new
    sync.pull
    puts "Done!"
end
