# -*- encoding: utf-8 -*-
# stub: fluent-plugin-mongo 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fluent-plugin-mongo".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Masahiro Nakagawa".freeze]
  s.date = "2019-04-24"
  s.description = "MongoDB plugin for Fluentd".freeze
  s.email = "repeatedly@gmail.com".freeze
  s.executables = ["mongo-tail".freeze]
  s.files = ["bin/mongo-tail".freeze]
  s.homepage = "https://github.com/fluent/fluent-plugin-mongo".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "MongoDB plugin for Fluentd".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<fluentd>.freeze, [">= 0.14.22", "< 2"])
    s.add_runtime_dependency(%q<mongo>.freeze, ["~> 2.6.0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0.9.2"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0.5.4"])
    s.add_development_dependency(%q<rr>.freeze, [">= 1.0.0"])
    s.add_development_dependency(%q<test-unit>.freeze, [">= 3.0.0"])
    s.add_development_dependency(%q<timecop>.freeze, ["~> 0.8.0"])
  else
    s.add_dependency(%q<fluentd>.freeze, [">= 0.14.22", "< 2"])
    s.add_dependency(%q<mongo>.freeze, ["~> 2.6.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0.9.2"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0.5.4"])
    s.add_dependency(%q<rr>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<test-unit>.freeze, [">= 3.0.0"])
    s.add_dependency(%q<timecop>.freeze, ["~> 0.8.0"])
  end
end
