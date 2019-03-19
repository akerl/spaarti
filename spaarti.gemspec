require 'English'
$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'spaarti/version'

Gem::Specification.new do |s|
  s.name        = 'spaarti'
  s.version     = Spaarti::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.summary     = 'Helper for cloning GitHub repos'
  s.description = 'Maintain local clones of repos you have access to on GitHub'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/spaarti'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split
  s.executables = ['spaarti']

  s.add_dependency 'cymbal', '~> 2.0.0'
  s.add_dependency 'mercenary', '~> 0.3.4'
  s.add_dependency 'octoauth', '~> 1.5.5'
  s.add_dependency 'octokit', '~> 4.13.0'

  s.add_development_dependency 'codecov', '~> 0.1.1'
  s.add_development_dependency 'fuubar', '~> 2.3.0'
  s.add_development_dependency 'goodcop', '~> 0.6.0'
  s.add_development_dependency 'rake', '~> 12.3.0'
  s.add_development_dependency 'rspec', '~> 3.8.0'
  s.add_development_dependency 'rubocop', '~> 0.66.0'
  s.add_development_dependency 'vcr', '~> 4.0.0'
  s.add_development_dependency 'webmock', '~> 3.5.1'
end
