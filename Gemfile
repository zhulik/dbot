source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'telegram-bot'
group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'spring-commands-rspec'
  gem 'awesome_print'
  gem 'hirb'
  gem 'pry'
  gem 'pry-byebug', platforms: [:mri]
  gem 'pry-rails'
end
