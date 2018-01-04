# frozen_string_literal: true

module MessageHandler
  extend ActiveSupport::Concern

  def message(*)
    return handle_text if payload.text.present?
    respond_with :message, text: t('common.i_dont_understand')
  end

  def message_callback_query(query)
    return if query != 'cancel'
    session.clear
    edit_message :text, text: t('common.canceled')
  end

  private

  def handle_text
    lang = Translators::YandexWrapper.new(payload.text).detect

    unless language_supported?(lang)
      return respond_with :message, text: t('common.unknown_language', lang: lang, current: current_language)
    end
    session[:message_to_handle] = payload.text
    return respond_for_native(payload.text, :translateto) if lang == 'ru'
    respond_for_foreign(payload.text, :translatefrom)
  end

  def respond_to_message(text, translate_context)
    respond_with :message, text: t('.what_do_you_want'),
                           reply_markup: { inline_keyboard: message_keyboard(text, translate_context) }
  end
end
