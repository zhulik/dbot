source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'telegram-bot'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'opie', github: 'zhulik/opie'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-its'
  gem 'spring-commands-rspec'
  gem 'awesome_print'
  gem 'hirb'
  gem 'pry'
  gem 'pry-rescue'
  gem 'pry-rails'
end

group :test do
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'rspec-mocks'
  gem 'webmock'
end
