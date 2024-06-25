# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'fluent-plugin-elasticsearch'
  s.version       = '2.12.5'
  s.authors       = ['diogo', 'pitr']
  s.email         = ['pitr.vern@gmail.com', 'me@diogoterror.com']
  s.description   = %q{Elasticsearch output plugin for Fluent event collector}
  s.summary       = s.description
  s.homepage      = 'https://github.com/uken/fluent-plugin-elasticsearch'
  s.license       = 'Apache-2.0'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)

  s.add_runtime_dependency 'fluentd', '>= 0.14.20'
  s.add_runtime_dependency 'excon', '>= 0'
  s.add_runtime_dependency 'elasticsearch'


  s.add_development_dependency 'rake', '>= 0'
  s.add_development_dependency 'webmock', '~> 1'
  s.add_development_dependency 'test-unit', '~> 3.1.0'
  s.add_development_dependency 'minitest', '~> 5.8'
  s.add_development_dependency 'flexmock', '~> 2.0'
end
