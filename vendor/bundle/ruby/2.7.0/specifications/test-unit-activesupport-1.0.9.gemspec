# -*- encoding: utf-8 -*-
# stub: test-unit-activesupport 1.0.9 ruby lib

Gem::Specification.new do |s|
  s.name = "test-unit-activesupport".freeze
  s.version = "1.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kouhei Sutou".freeze]
  s.date = "2017-07-26"
  s.description = "".freeze
  s.email = ["kou@clear-code.com".freeze]
  s.homepage = "https://github.com/test-unit/test-unit-activesupport".freeze
  s.licenses = ["LGPL-2.1".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "test-unit-activesupport is an ActiveSupport adapter for test-unit 3. You can use full test-unit 3 features with `ActiveSupport::TestCase`.".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<test-unit>.freeze, [">= 0"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<test-unit-notify>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<packnga>.freeze, [">= 0"])
    s.add_development_dependency(%q<kramdown>.freeze, [">= 0"])
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_dependency(%q<test-unit>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<test-unit-notify>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<packnga>.freeze, [">= 0"])
    s.add_dependency(%q<kramdown>.freeze, [">= 0"])
  end
end
