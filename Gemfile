source 'https://rubygems.org'

gemspec

# spec.add_development_dependency gems doesn't installed by `gem install fluentd-ui`, but required them from config/application.rb, then error.
# this is workaround for that.
group :development, :test do
  gem "rake"
  gem "pry"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.0"
end

group :development do
  gem 'i18n_generators', '1.2.1'
  gem 'better_errors'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem "factory_girl_rails"
  gem "capybara", "~> 2.18.0"
  gem "capybara-screenshot"
  gem "simplecov", "~> 0.16.1", require: false
  gem "webmock", "~> 3.3.0"
  gem "timecop"
  gem "poltergeist"
end
