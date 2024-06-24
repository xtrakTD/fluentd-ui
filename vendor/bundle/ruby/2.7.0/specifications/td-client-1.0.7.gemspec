# -*- encoding: utf-8 -*-
# stub: td-client 1.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "td-client".freeze
  s.version = "1.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Treasure Data, Inc.".freeze]
  s.date = "2019-06-04"
  s.description = "Treasure Data API library for Ruby".freeze
  s.email = "support@treasure-data.com".freeze
  s.homepage = "http://treasuredata.com/".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1".freeze)
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Treasure Data API library for Ruby".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<msgpack>.freeze, [">= 0.5.6", "< 2"])
    s.add_runtime_dependency(%q<httpclient>.freeze, [">= 2.7"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<coveralls>.freeze, [">= 0"])
    s.add_development_dependency(%q<webmock>.freeze, ["~> 1.16"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0.5.4"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<yard>.freeze, [">= 0"])
  else
    s.add_dependency(%q<msgpack>.freeze, [">= 0.5.6", "< 2"])
    s.add_dependency(%q<httpclient>.freeze, [">= 2.7"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<coveralls>.freeze, [">= 0"])
    s.add_dependency(%q<webmock>.freeze, ["~> 1.16"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0.5.4"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<yard>.freeze, [">= 0"])
  end
end
