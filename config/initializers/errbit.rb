# frozen_string_literal: true

Airbrake.configure do |config|
  config.host = Rails.application.secrets.airbrake[:host]
  config.project_id = 1
  config.project_key = Rails.application.secrets.airbrake[:project_key]

  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end

module Patches
  module Airbrake
    module SyncSender
      def build_https(uri)
        super.tap do |req|
          req.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end
    end
  end
end

Airbrake::SyncSender.prepend(::Patches::Airbrake::SyncSender)
