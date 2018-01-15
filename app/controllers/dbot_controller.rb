# frozen_string_literal: true

class DbotController < Telegram::Bot::UpdatesController
  include ActiveSupport::Rescuable

  include Telegram::Bot::UpdatesController::CallbackQueryContext
  include Telegram::Bot::UpdatesController::TypedUpdate
  include Telegram::Bot::UpdatesController::MessageContext

  include ApplicationHelper
  include UsersHelper
  include ButtonsHelper

  self.session_store = :redis_store, { expires_in: 1.month }

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :authenticate!, except: :start
  before_action :check_language!, only: %i[addword delword words practice translateto translatefrom message]
  # rubocop:enable Rails/LexicallyScopedActionFilter

  rescue_from StandardError, with: :send_error_and_raise
  rescue_from NotStartedError, with: :send_not_authorized
  rescue_from LanguageNotSetError, with: :send_select_language

  def message(*_args)
    if context.present?
      ctx_tokens = context.to_s.split('_')
      return command_for(ctx_tokens.first).send(ctx_tokens[1..-1].join('_'), *payload['text']&.split)
    end
    return handle_text if payload.text.present?
    respond_message text: t('common.i_dont_understand')
  end

  def message_callback_query(query)
    return if query != 'cancel'
    session.clear
    respond_message text: t('common.canceled')
  end

  def _handle_action_missing(*args)
    command_for(action_name).message(*args)
  rescue NameError
    respond_message text: t('common.unknown_command')
  end

  def callback_query(query)
    tokens = query.split(':')
    ctx_tokens = tokens.first.split('_')
    sub_ctx = ctx_tokens[1..-1]
    sub_ctx = sub_ctx.any? ? sub_ctx.join('_') + '_' : ''
    command_for(ctx_tokens.first).send("#{sub_ctx}callback_query", tokens[1..-1].join(':'))
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
    raise e
  end

  def authenticate!
    raise NotStartedError if current_user.nil?
  end

  def check_language!
    raise LanguageNotSetError if current_user.language.nil?
  end

  def send_select_language
    respond_message text: t('common.select_language')
  end

  def handle_text
    lang = Translators::YandexWrapper.new(payload.text).detect

    unless language_supported?(lang)
      return respond_message text: t('common.unknown_language', lang: lang, current: current_language)
    end
    session[:message_to_handle] = payload.text
    ctx = lang == 'ru' ? :translateto : :translatefrom
    respond_to_message payload.text, ctx
  end

  def respond_to_message(text, translate_context)
    respond_message text: t('.what_do_you_want'),
                    reply_markup: { inline_keyboard: message_keyboard(text, translate_context) }
  end

  def command_for(name)
    "#{name}_command".camelize.constantize.new(bot, session, payload)
  end

  def message_keyboard(text, translate_context)
    [
      { text: t('.feedback'), callback_data: 'feedback:message' },
      { text: t('.translate'), callback_data: "#{translate_context}:message" },
      { text: t('.pronounce'), callback_data: 'pronounce:message' },
      cancel_button(:message)
    ].tap do |keys|
      clean = text.tr('.', ' ').strip
      keys << { text: t('common.add_word', word: clean), callback_data: "addword:#{clean}" } if clean.split.one?
    end.each_slice(2).to_a
  end
end
