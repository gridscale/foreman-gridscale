require File.expand_path('../lib/foreman_gridscale/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'foreman_gridscale'
  s.version     = ForemanGridscale::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = ['Aldemuro Haris', 'Wouter Wijsman']
  s.email       = ['aldemuro@gridscale.io', 'wouter@gridscale.io']
  s.homepage    = 'https://github.com/gridscale/foreman-gridscale'
  s.summary     = 'Provision and manage gridscale instances from Foreman'
  # also update locale/gemspec.rb
  s.description = 'gridscale provider for Foreman'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop', "~> 0.61"
  s.add_development_dependency 'rdoc', '~> 6.1'
  s.add_dependency 'fog-gridscale', '~> 0.1'
end
