# -*- encoding: utf-8 -*-
# stub: kramdown-haml 0.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "kramdown-haml".freeze
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["".freeze]
  s.date = "2013-09-05"
  s.description = "HAML filter for Kramdown".freeze
  s.email = ["".freeze]
  s.homepage = "".freeze
  s.rubygems_version = "3.1.6".freeze
  s.summary = "HAML filter for Kramdown".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<haml>.freeze, [">= 0"])
  else
    s.add_dependency(%q<haml>.freeze, [">= 0"])
  end
end
