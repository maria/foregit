require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = 'test/'
end

desc "Run tests"
task :default => :spec
