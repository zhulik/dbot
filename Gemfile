source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'telegram-bot', require: false
gem 'telegram-bot-types', require: false
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'opie', github: 'zhulik/opie'
gem 'yandex-translator'
gem 'rails_admin'
gem 'redis-rails'
gem 'listen', '>= 3.0.5', '< 3.2'
gem 'airbrake', '~> 5.0'
gem 'language_list'
gem 'sidekiq'

group :development do
  gem 'rubocop', require: false
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'awesome_print'
  gem 'hirb'
  gem 'pry'
  gem 'pry-rescue'
  gem 'pry-rails'
  gem 'simplecov', require: false
  gem 'capistrano3-puma'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-mocks'
  gem 'webmock'
  gem 'vcr'
end
