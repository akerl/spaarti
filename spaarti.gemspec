require 'English'
$LOAD_PATH.unshift File.expand_path('../lib/', __FILE__)
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

  s.add_dependency 'octokit', '~> 4.7.0'
  s.add_dependency 'octoauth', '~> 1.4.7'
  s.add_dependency 'mercenary', '~> 0.3.4'
  s.add_dependency 'cymbal', '~> 1.0.0'

  s.add_development_dependency 'rubocop', '~> 0.50.0'
  s.add_development_dependency 'goodcop', '~> 0.1.0'
  s.add_development_dependency 'rake', '~> 12.1.0'
  s.add_development_dependency 'codecov', '~> 0.1.1'
  s.add_development_dependency 'rspec', '~> 3.7.0'
  s.add_development_dependency 'fuubar', '~> 2.2.0'
  s.add_development_dependency 'webmock', '~> 3.1.0'
  s.add_development_dependency 'vcr', '~> 3.0.0'
end
