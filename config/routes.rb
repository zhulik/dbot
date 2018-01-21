# frozen_string_literal: true

require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  salt = Rails.application.secrets.rails_admin_salt
  ActiveSupport::SecurityUtils.secure_compare(Digest::SHA256.hexdigest("#{username}:#{password}:#{salt}"), AUTH_HASH)
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/admin/sidekiq'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  telegram_webhooks DbotController
end
