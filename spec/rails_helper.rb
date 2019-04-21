# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require 'rails/all'
require 'telegram/bot'
require 'telegram/bot/railtie'
require 'telegram/bot/types'

require File.expand_path('../config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'telegram/bot/rspec/integration'
require 'vcr'
require 'sidekiq/testing'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| load(f) }

ActiveRecord::Migration.maintain_test_schema!

Sidekiq::Testing.inline!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean!
  end
  config.after { Telegram.bot.reset }

  config.define_derived_metadata(file_path: Regexp.new('/spec/telegram_bots/')) do |metadata|
    metadata[:type] = :telegram_bot
  end
  config.infer_spec_type_from_file_location!
  config.include_context 'telegram/bot/session', type: :telegram_bot
  config.include_context 'telegram/bot/callback_query_helpers', type: :telegram_bot
  config.include_context 'telegram/bot/callback_query', type: :telegram_bot
  config.include_context 'telegram/bot/integration', type: :telegram_bot
  config.include RSpec::Rails::RequestExampleGroup, type: :telegram_bot
end
