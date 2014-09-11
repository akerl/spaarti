Gem::Specification.new do |s|
  s.name        = 'spaarti'
  s.version     = '0.0.0'
  s.date        = Time.now.strftime("%Y-%m-%d")

  s.summary     = 'Tool to maintain local clones of repos you have access to on GitHub'
  s.description = "Tool to maintain local clones of repos you have access to on GitHub"
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/spaarti'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split

  s.add_development_dependency 'rubocop', '~> 0.26.0'
  s.add_development_dependency 'rake', '~> 10.3.2'
  s.add_development_dependency 'coveralls', '~> 0.7.0'
  s.add_development_dependency 'rspec', '~> 3.1.0'
  s.add_development_dependency 'fuubar', '~> 2.0.0'
end
