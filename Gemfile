source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', "~>5.2"
gem 'telegram-bot', require: false
gem 'telegram-bot-types', require: false

gem 'pg'
gem 'puma'
gem 'tzinfo-data'
gem 'yandex-dictionary', github: 's-mage/yandex-dictionary', require: 'yandex_dictionary'
gem 'yandex-translator'
gem 'rails_admin'
gem 'redis-rails'
gem 'language_list'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'nokogiri'
gem 'german_numbers', '~>0.5.0'
gem 'pickup'
gem 'voicerss2017'
gem 'carrierwave'
gem 'enum_attributes_validation', github: 'CristiRazvi/enum_attributes_validation'

gem 'bootsnap', require: false

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'solargraph', require: false
  gem 'overcommit', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'listen'
  gem 'dotenv-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-mocks'
  gem 'webmock'
  gem 'vcr'
end
