# -*- encoding: utf-8 -*-
# stub: test-unit-rails 5.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "test-unit-rails".freeze
  s.version = "5.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kouhei Sutou".freeze]
  s.date = "2018-08-20"
  s.description = "Rails supports Minitest but doesn't support test-unit.\n".freeze
  s.email = ["kou@clear-code.com".freeze]
  s.homepage = "https://github.com/test-unit/test-unit-rails".freeze
  s.licenses = ["LGPLv2 or later".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "test-unit-rails is a Rails adapter for test-unit gem. You can use full test-unit gem features, [RR](https://rubygems.org/gems/rr) integration and [Capybara](https://rubygems.org/gems/capybara) integration with test-unit-rails.".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<rails>.freeze, [">= 5.1.2"])
    s.add_runtime_dependency(%q<test-unit-activesupport>.freeze, [">= 1.0.8"])
    s.add_runtime_dependency(%q<test-unit-capybara>.freeze, [">= 1.0.5"])
    s.add_runtime_dependency(%q<test-unit-rr>.freeze, [">= 1.0.4"])
    s.add_runtime_dependency(%q<test-unit>.freeze, [">= 3.1.7"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<packnga>.freeze, [">= 0"])
    s.add_development_dependency(%q<kramdown>.freeze, [">= 0"])
    s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_development_dependency(%q<selenium-webdriver>.freeze, [">= 0"])
    s.add_development_dependency(%q<chromedriver-helper>.freeze, [">= 0"])
  else
    s.add_dependency(%q<rails>.freeze, [">= 5.1.2"])
    s.add_dependency(%q<test-unit-activesupport>.freeze, [">= 1.0.8"])
    s.add_dependency(%q<test-unit-capybara>.freeze, [">= 1.0.5"])
    s.add_dependency(%q<test-unit-rr>.freeze, [">= 1.0.4"])
    s.add_dependency(%q<test-unit>.freeze, [">= 3.1.7"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<packnga>.freeze, [">= 0"])
    s.add_dependency(%q<kramdown>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<selenium-webdriver>.freeze, [">= 0"])
    s.add_dependency(%q<chromedriver-helper>.freeze, [">= 0"])
  end
end
