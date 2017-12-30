# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::TypedUpdate
  include UsersHelper

  def start
    if current_user.nil?
      respond_with :message, text: t('.hi', name: user_greeting(payload.from))
      return
    end
    return respond_with :message, text: t('.already_started') if current_user.active?
  end
end
