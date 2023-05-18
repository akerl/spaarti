require 'English'
$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'spaarti/version'

Gem::Specification.new do |s|
  s.name        = 'spaarti'
  s.version     = Spaarti::VERSION
  s.required_ruby_version = '>= 2.7'

  s.summary     = 'Helper for cloning GitHub repos'
  s.description = 'Maintain local clones of repos you have access to on GitHub'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/spaarti'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.executables = ['spaarti']

  s.add_dependency 'cymbal', '~> 2.0.0'
  s.add_dependency 'mercenary', '~> 0.3.4'
  s.add_dependency 'octoauth', '~> 2.0.0'
  s.add_dependency 'octokit', '~> 5.6.1'

  s.add_development_dependency 'goodcop', '~> 0.9.7'
  s.add_development_dependency 'vcr', '~> 5.0.0'
  s.add_development_dependency 'webmock', '~> 3.7.6'
  s.metadata['rubygems_mfa_required'] = 'true'
end
