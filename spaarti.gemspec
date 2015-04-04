$:.unshift File.expand_path('../lib/', __FILE__)
require 'spaarti/version'

Gem::Specification.new do |s|
  s.name        = 'spaarti'
  s.version     = Spaarti::VERSION
  s.date        = Time.now.strftime("%Y-%m-%d")

  s.summary     = 'Helper for cloning GitHub repos'
  s.description = 'Maintain local clones of repos you have access to on GitHub'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/spaarti'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split
  s.executables = ['spaarti']

  s.add_dependency 'octokit', '~> 3.8.0'
  s.add_dependency 'octoauth', '~> 1.0.1'
  s.add_dependency 'mercenary', '~> 0.3.4'
  s.add_dependency 'cymbal', '~> 1.0.0'

  s.add_development_dependency 'rubocop', '~> 0.29.0'
  s.add_development_dependency 'rake', '~> 10.4.0'
  s.add_development_dependency 'coveralls', '~> 0.8.0'
  s.add_development_dependency 'rspec', '~> 3.2.0'
  s.add_development_dependency 'fuubar', '~> 2.0.0'
end
