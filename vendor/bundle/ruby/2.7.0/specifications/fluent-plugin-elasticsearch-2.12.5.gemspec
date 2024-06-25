# -*- encoding: utf-8 -*-
# stub: fluent-plugin-elasticsearch 2.12.5 ruby lib

Gem::Specification.new do |s|
  s.name = "fluent-plugin-elasticsearch".freeze
  s.version = "2.12.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["diogo".freeze, "pitr".freeze]
  s.date = "2018-12-14"
  s.description = "Elasticsearch output plugin for Fluent event collector".freeze
  s.email = ["pitr.vern@gmail.com".freeze, "me@diogoterror.com".freeze]
  s.homepage = "https://github.com/uken/fluent-plugin-elasticsearch".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Elasticsearch output plugin for Fluent event collector".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<fluentd>.freeze, [">= 0.14.20"])
    s.add_runtime_dependency(%q<excon>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<elasticsearch>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<webmock>.freeze, ["~> 1"])
    s.add_development_dependency(%q<test-unit>.freeze, ["~> 3.1.0"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.8"])
    s.add_development_dependency(%q<flexmock>.freeze, ["~> 2.0"])
  else
    s.add_dependency(%q<fluentd>.freeze, [">= 0.14.20"])
    s.add_dependency(%q<excon>.freeze, [">= 0"])
    s.add_dependency(%q<elasticsearch>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<webmock>.freeze, ["~> 1"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 3.1.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.8"])
    s.add_dependency(%q<flexmock>.freeze, ["~> 2.0"])
  end
end
