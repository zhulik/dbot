# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include ActiveSupport::Rescuable
  include Telegram::Bot::UpdatesController::TypedUpdate
  include UsersHelper
  include KeyboardsHelper

  rescue_from NotStartedError, with: :not_authorized
  around_action :rescue_not_authorized, except: :start

  before_action :authenticate!, except: :start

  def start
    return start_with_existing_user if current_user.present?

    User.create!(user_id: from.id)
    respond_with :message, text: t('.hi', name: user_greeting(from))
  end

  def languages
    return respond_with :message, text: t('.no_languages') if Language.all.empty?
    respond_with :message, text: t('.choose_language'), reply_markup: languages_keyboard
  end

  def callback_query(data)
    language = Language.find_by(slug: data)
    answer_callback_query t('.language_accepted', name: language.name)
  end

  private

  def authenticate!
    raise NotStartedError if current_user.nil?
  end

  def start_with_existing_user
    return respond_with :message, text: t('.already_started') if current_user.active?

    current_user.update_attributes(active: true)
    respond_with :message, text: t('.reactivated')
  end

  def rescue_not_authorized
    yield
  rescue NotStartedError
    return respond_with :message, text: t('common.not_authorized')
  end
end
