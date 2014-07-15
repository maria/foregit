# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|

  s.name          = 'hammer_cli_foregit'
  s.version       = '0.1'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Maria Nita']
  s.license       = 'GPL v3+'

  s.summary       = %q{An interface between Foreman and Git}
  s.description   =  %q{An interface to configure Foreman through a Git repository}

  s.files = Dir['{lib,spec,bin,doc,config}/**/*', 'LICENSE', 'README*', 'Rakefile']
  s.require_paths = ['lib']

  s.add_dependency 'hammer_cli', '>= 0.1.1'
  s.add_dependency 'apipie-bindings', '>=0.0.8'
  s.add_dependency 'commander', '=> 4.2.0'
  s.add_dependency 'git', '>=1.2.6'
end
