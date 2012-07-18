# -*- encoding: utf-8 -*-
require File.expand_path('../lib/redis_pagination/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['David Czarnecki']
  gem.email         = ['me@davidczarnecki.com']
  gem.description   = %q{Simple pagination for Redis lists and sorted sets.}
  gem.summary       = %q{Simple pagination for Redis lists and sorted sets.}
  gem.homepage      = 'https://github.com/czarneckid/redis_pagination'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'redis_pagination'
  gem.require_paths = ['lib']
  gem.version       = RedisPagination::VERSION

  gem.add_dependency('redis')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec')
end
