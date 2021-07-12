# frozen_string_literal: true

CarrierWave.configure do |config|
  config.storage = :file
  config.asset_host = ENV.fetch('RAILS_ASSETS_HOST')
end
