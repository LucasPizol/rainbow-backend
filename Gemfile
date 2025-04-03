source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem 'rack-cors'
gem 'rspec'
gem 'paper_trail'
gem 'kaminari'

gem "bcrypt", "~> 3.1.7"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false

gem "thruster", require: false
gem "jb"
gem "jwt", require: false
gem "aws-sdk-s3"
gem "ransack"
gem "devise", "~> 4.9"
gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "annotate"
  gem "brakeman", require: false
  gem 'factory_bot_rails'

  gem 'rspec-rails'
  gem 'faker'
  gem 'byebug'

  gem 'rubocop', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-discourse', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end

gem "rails_icons", "~> 1.2"
