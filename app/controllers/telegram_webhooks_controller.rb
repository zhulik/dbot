# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::TypedUpdate
  include UsersHelper

  def start
    return start_with_existing_user if current_user.present?

    User.create!(user_id: payload.from.id)
    respond_with :message, text: t('.hi', name: user_greeting(payload.from))
  end

  private

  def start_with_existing_user
    return respond_with :message, text: t('.already_started') if current_user.active?

    current_user.update_attributes(active: true)
    respond_with :message, text: t('.reactivated')
  end
end
