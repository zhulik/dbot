# frozen_string_literal: true

class DbotController < Telegram::Bot::UpdatesController
  include ActiveSupport::Rescuable

  include Telegram::Bot::UpdatesController::CallbackQueryContext
  include Telegram::Bot::UpdatesController::TypedUpdate
  include Telegram::Bot::UpdatesController::MessageContext

  include ApplicationHelper

  self.session_store = :redis_store, { expires_in: 1.month }

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :authenticate!, except: :start
  before_action :check_language!, only: %i[addword delword words practice translateto translatefrom message]
  # rubocop:enable Rails/LexicallyScopedActionFilter

  rescue_from StandardError, with: :send_error_and_raise
  rescue_from NotStartedError, with: :send_not_authorized
  rescue_from LanguageNotSetError, with: :send_select_language
  rescue_from UnknownCommandError, with: :send_unknown_command
  rescue_from NoWordsAddedError, with: :send_no_words_added

  def _handle_action_missing(*)
    Router.new(bot, session, payload, action_name, context).handle!
  end

  private

  def process_action(*args)
    super
  rescue StandardError => exception
    rescue_with_handler(exception) || raise
  end

  def send_not_authorized
    return answer_callback_query t('common.not_authorized') if payload.is_a? Telegram::Bot::Types::CallbackQuery
    respond_message text: t('common.not_authorized')
  end

  def send_error_and_raise(e)
    if payload.is_a? Telegram::Bot::Types::CallbackQuery
      answer_callback_query t('common.something_went_wrong')
    else
      respond_message text: t('common.something_went_wrong')
    end
    raise e # TODO: don't raise, only send to Errbit
  end

  def authenticate!
    raise NotStartedError if current_user.nil?
  end

  def check_language!
    raise LanguageNotSetError if current_language.nil?
  end

  def send_select_language
    respond_message text: t('common.select_language')
  end

  def send_unknown_command
    respond_message text: t('common.unknown_command')
  end

  def send_no_words_added
    respond_message text: t('dbot.words.no_words_added')
  end
end
