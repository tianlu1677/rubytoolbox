# frozen_string_literal: true

# source "https://rubygems.org"
# source "https://gems.ruby-china.com"
source 'https://mirrors.tuna.tsinghua.edu.cn/rubygems/'

ruby File.read(File.join(__dir__, ".ruby-version")).strip

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", "~> 6.1.0"

# Use postgresql as the database for Active Record
gem "hairtrigger"
gem "pg", "~> 1.2.3"
gem "pg_search"
gem "kaminari"

gem "puma", "~> 5.0.4"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"

# Heroku ruby buildpack installs yarn only when webpacker gem is detected...
gem "webpacker", require: false

gem "font-awesome-rails", github: 'bokmann/font-awesome-rails', branch: :master
gem 'se-api', github: 'tianlu1677/se-api', branch: :master

gem "addressable"

gem "blueprinter"

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

gem "bootsnap", ">= 1.1.0", require: false
gem "foreman", require: false
gem "dotenv-rails"
gem "appsignal"
gem "forgery"
gem "rack-canonical-host"
gem "rack-ssl-enforcer"
gem "browser"
gem "github_webhook"
gem "high_voltage"
gem "http"
gem "sidekiq"
gem "sanitize"
gem "truncato"
gem 'acts-as-taggable-on', github: 'mbleigh/acts-as-taggable-on', branch: :master

gem "redcarpet"
gem "slim-rails"

gem "rouge"

# Shorter request logs
gem "lograge"
# Needed for logstash json_event formatter for lograge
gem "logstash-event"

# Faster JSON
gem "oj"

gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
gem "rack-cors"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "pry-rails"
  gem "rspec-rails", ">= 4.0"
  gem "annotate"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15", "< 4.0"
  gem "launchy"
  gem "selenium-webdriver"
  # Easy installation and use of selenium webdriver browsers to run system tests
  gem "webdrivers"

  gem "percy-capybara", require: "percy"

  gem "feedjira"

  gem "db-query-matchers"

  gem "retriable"

  gem "timecop"

  gem "rspec_junit_formatter"
  gem "rspec-retry"

  gem "rails-controller-testing"
  gem "simplecov", require: false

  gem "vcr"
  gem "webmock", require: "webmock/rspec"
end

group :development do
  gem "brakeman", require: false
  gem "bundler-audit", require: false

  gem "pghero"

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  gem "guard-bundler", require: false
  gem "guard-rspec", require: false
  gem "guard-rubocop", require: false

  gem "overcommit", require: false

  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
