source "https://rubygems.org"

gem "rails", "~> 8.0.5"
gem "dotenv-rails", groups: %i[development test]
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# Auth
gem "devise"

# Payments
gem "razorpay"
gem "stripe"


# Image uploads
gem "image_processing", "~> 1.2"
gem "aws-sdk-s3", require: false

# Pagination
gem "pagy", "~> 43.5"

# Search / filter
gem "ransack"

# Authorization
gem "cancancan"

# Windows timezone data
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Rails 8 solid adapters
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
end
