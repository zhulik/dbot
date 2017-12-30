# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::TypedUpdate
  include UsersHelper

  def start
    respond_with :message, text: t('.hi', name: user_greeting(payload.from))
  end
end
