# -*- encoding: utf-8 -*-
# stub: test-unit-capybara 1.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "test-unit-capybara".freeze
  s.version = "1.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kouhei Sutou".freeze]
  s.date = "2018-08-27"
  s.description = "".freeze
  s.email = ["kou@clear-code.com".freeze]
  s.homepage = "https://github.com/test-unit/test-unit-capybara".freeze
  s.licenses = ["LGPLv2 or later".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "test-unit-capybara is a Capybara adapter for test-unit 2. You can get [Capybara](https://rubygems.org/gems/capybara) integrated Test::Unit::TestCase. It also provides useful assertions for Capybara.".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<test-unit>.freeze, [">= 2.5.3"])
    s.add_runtime_dependency(%q<capybara>.freeze, [">= 2.1.0"])
    s.add_runtime_dependency(%q<json>.freeze, [">= 0"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<yard>.freeze, [">= 0"])
    s.add_development_dependency(%q<packnga>.freeze, [">= 0"])
    s.add_development_dependency(%q<test-unit-notify>.freeze, [">= 0"])
    s.add_development_dependency(%q<redcarpet>.freeze, [">= 0"])
  else
    s.add_dependency(%q<test-unit>.freeze, [">= 2.5.3"])
    s.add_dependency(%q<capybara>.freeze, [">= 2.1.0"])
    s.add_dependency(%q<json>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<yard>.freeze, [">= 0"])
    s.add_dependency(%q<packnga>.freeze, [">= 0"])
    s.add_dependency(%q<test-unit-notify>.freeze, [">= 0"])
    s.add_dependency(%q<redcarpet>.freeze, [">= 0"])
  end
end
