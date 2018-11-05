require File.expand_path('../lib/foreman_gridscale/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'foreman_gridscale'
  s.version     = ForemanGridscale::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = ['gridscale']
  s.email       = ['']
  s.homepage    = 'https://bitbucket.org/gridscale/foreman-gridscale/src/master/'
  s.summary     = ''
  # also update locale/gemspec.rb
  s.description = 'gridscale provider for Foreman'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
  s.add_dependency 'fog-gridscale'
end
