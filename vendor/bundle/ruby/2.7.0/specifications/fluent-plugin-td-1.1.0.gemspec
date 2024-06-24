# -*- encoding: utf-8 -*-
# stub: fluent-plugin-td 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fluent-plugin-td".freeze
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Treasure Data, Inc.".freeze]
  s.date = "2019-12-18"
  s.description = "Treasure Data Cloud Data Service plugin for Fluentd".freeze
  s.email = "support@treasure-data.com".freeze
  s.homepage = "http://www.treasuredata.com/".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Treasure Data Cloud Data Service plugin for Fluentd".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<fluentd>.freeze, [">= 0.14.13", "< 2"])
    s.add_runtime_dependency(%q<td-client>.freeze, ["~> 1.0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0.9.2"])
    s.add_development_dependency(%q<webmock>.freeze, ["~> 1.16"])
    s.add_development_dependency(%q<test-unit>.freeze, ["~> 3.0.8"])
    s.add_development_dependency(%q<test-unit-rr>.freeze, ["~> 1.0.3"])
  else
    s.add_dependency(%q<fluentd>.freeze, [">= 0.14.13", "< 2"])
    s.add_dependency(%q<td-client>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0.9.2"])
    s.add_dependency(%q<webmock>.freeze, ["~> 1.16"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 3.0.8"])
    s.add_dependency(%q<test-unit-rr>.freeze, ["~> 1.0.3"])
  end
end
