# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require 'rails/all'
require 'telegram/bot'
require 'telegram/bot/railtie'
require 'telegram/bot/types'

require File.expand_path('../../config/environment', __FILE__)

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'telegram/bot/rspec/integration'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| load(f) }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean!
  end
  config.after { Telegram.bot.reset }
  config.include_context 'telegram/bot/session', :telegram_bot
end
