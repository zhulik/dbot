# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Telegram.bots_config = {
  default: ENV['TELEGRAM_BOT_TOKEN']
}

Rails.application.routes.draw do
  mount Sidekiq::Web => '/admin/sidekiq'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  telegram_webhook DbotController
end
