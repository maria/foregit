# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|

  s.name          = "foregit"
  s.version       = '0.1'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Maria Nita"]
  s.license       = "GPL-3"

  s.summary       = %q{An interface between Foreman and Git}
  s.description   =  %q{An interface to configure Foreman through a Git repository}

  s.require_paths    = ["lib"]

  s.add_dependency 'apipie-bindings', '>= 0.0.8'

end
