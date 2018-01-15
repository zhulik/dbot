# frozen_string_literal: true

class MessageHandler < Handler
  def message(*)
    return handle_text if payload.text.present?
    respond_message text: t('common.i_dont_understand')
  end

  def callback_query(query)
    return if query != 'cancel'
    session.clear
    respond_message text: t('common.canceled')
  end

  private

  def handle_text
    lang = Translators::YandexWrapper.new(payload.text).detect

    unless language_supported?(lang)
      return respond_message text: t('common.unknown_language', lang: lang, current: current_language)
    end
    session[:message_to_handle] = payload.text
    ctx = lang == 'ru' ? :translateto : :translatefrom
    respond_to_message(payload.text, ctx)
  end

  def respond_to_message(text, translate_context)
    respond_message text: t('dbot.message.what_do_you_want'),
                    reply_markup: { inline_keyboard: message_keyboard(text, translate_context) }
  end

  def message_keyboard(text, translate_context)
    [
      { text: t('dbot.message.feedback'), callback_data: 'feedback:message' },
      { text: t('dbot.message.translate'), callback_data: "#{translate_context}:message" },
      { text: t('dbot.message.pronounce'), callback_data: 'pronounce:message' },
      cancel_button(:message)
    ].tap do |keys|
      clean = text.tr('.', ' ').strip
      keys << { text: t('common.add_word', word: clean), callback_data: "addword:#{clean}" } if clean.split.one?
    end.each_slice(2).to_a
  end

  def language_supported?(lang)
    ['ru', current_language].include?(lang)
  end
end
