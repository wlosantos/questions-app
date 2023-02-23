# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4', '>= 7.0.4.2'

gem 'bcrypt', '~> 3.1.7'
gem 'jwt'
gem 'pundit'
gem 'rack-cors'
gem 'rolify'

gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'rspec-rails'

  # Security tools
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'ruby_audit'

  # Linting tools
  gem 'rubocop'
  gem 'rubocop-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 4.5', '>= 4.5.1'
end

group :development do
  gem 'letter_opener'
end
