# frozen_string_literal: true

class DbotController < Telegram::Bot::UpdatesController
  include ActiveSupport::Rescuable

  include ControllerConfig
  include StartCommand
  include LanguagesCommand
  include WordsCommand
  include DelwordCommand
  include AddwordCommand

  rescue_from StandardError, with: :send_error_and_raise
  rescue_from NotStartedError, with: :send_not_authorized

  private

  def process_action(*args)
    super
  rescue StandardError => exception
    rescue_with_handler(exception) || raise
  end

  def send_not_authorized
    return answer_callback_query t('common.not_authorized') if payload.is_a? Telegram::Bot::Types::CallbackQuery
    respond_with :message, text: t('common.not_authorized')
  end

  def send_error_and_raise(e)
    if payload.is_a? Telegram::Bot::Types::CallbackQuery
      answer_callback_query t('common.something_went_wrong')
    else
      respond_with :message, text: t('common.something_went_wrong')
    end
    raise e
  end
end
