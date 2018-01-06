# frozen_string_literal: true

CarrierWave.configure do |config|
  config.storage = :file
  config.asset_host = 'https://dbot.lighty.photo'
end
