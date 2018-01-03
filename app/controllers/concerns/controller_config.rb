# frozen_string_literal: true

# rubocop:disable Rails/LexicallyScopedActionFilter
module ControllerConfig
  extend ActiveSupport::Concern

  included do
    include Telegram::Bot::UpdatesController::CallbackQueryContext
    include Telegram::Bot::UpdatesController::TypedUpdate
    include Telegram::Bot::UpdatesController::MessageContext
    include UsersHelper
    include KeyboardsHelper

    self.session_store = :redis_store, { expires_in: 1.month }
    before_action :authenticate!, except: :start
  end

  def authenticate!
    raise NotStartedError if current_user.nil?
  end
end

# rubocop:enable Rails/LexicallyScopedActionFilter
