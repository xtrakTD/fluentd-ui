# -*- encoding: utf-8 -*-
# stub: fluent-plugin-s3 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fluent-plugin-s3".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sadayuki Furuhashi".freeze, "Masahiro Nakagawa".freeze]
  s.date = "2020-02-10"
  s.description = "Amazon S3 output plugin for Fluentd event collector".freeze
  s.email = "frsyuki@gmail.com".freeze
  s.homepage = "https://github.com/fluent/fluent-plugin-s3".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Amazon S3 output plugin for Fluentd event collector".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<fluentd>.freeze, [">= 0.14.22", "< 2"])
    s.add_runtime_dependency(%q<aws-sdk-s3>.freeze, ["~> 1.60"])
    s.add_runtime_dependency(%q<aws-sdk-sqs>.freeze, ["~> 1.23"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0.9.2"])
    s.add_development_dependency(%q<test-unit>.freeze, [">= 3.0.8"])
    s.add_development_dependency(%q<test-unit-rr>.freeze, [">= 1.0.3"])
    s.add_development_dependency(%q<timecop>.freeze, [">= 0"])
  else
    s.add_dependency(%q<fluentd>.freeze, [">= 0.14.22", "< 2"])
    s.add_dependency(%q<aws-sdk-s3>.freeze, ["~> 1.60"])
    s.add_dependency(%q<aws-sdk-sqs>.freeze, ["~> 1.23"])
    s.add_dependency(%q<rake>.freeze, [">= 0.9.2"])
    s.add_dependency(%q<test-unit>.freeze, [">= 3.0.8"])
    s.add_dependency(%q<test-unit-rr>.freeze, [">= 1.0.3"])
    s.add_dependency(%q<timecop>.freeze, [">= 0"])
  end
end
