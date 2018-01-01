# frozen_string_literal: true

# rubocop:disable Rails/LexicallyScopedActionFilter
module ControllerConfig
  extend ActiveSupport::Concern

  included do
    include Telegram::Bot::UpdatesController::TypedUpdate
    include Telegram::Bot::UpdatesController::MessageContext
    include UsersHelper
    include KeyboardsHelper

    self.session_store = :redis_store, { expires_in: 1.month }

    around_action :rescue_not_authorized, except: :start

    before_action :authenticate!, except: :start
  end

  def rescue_not_authorized
    yield
  rescue NotStartedError
    return answer_callback_query t('common.not_authorized') if payload.is_a? Telegram::Bot::Types::CallbackQuery
    return respond_with :message, text: t('common.not_authorized')
  end

  def authenticate!
    raise NotStartedError if current_user.nil?
  end
end

# rubocop:enable Rails/LexicallyScopedActionFilter
