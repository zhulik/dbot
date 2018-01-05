# frozen_string_literal: true

module TranslatetoCommand
  extend ActiveSupport::Concern

  included do
    context_handler :translateto_send_sentence do |*ws|
      translateto_direct(ws.join(' '))
    end
  end

  def translateto(*ws)
    return translateto_full if ws.empty?
    translateto_direct(ws.join(' '))
  end

  def translateto_callback_query(_query)
    message = session.delete(:message_to_handle)
    reply_markup, text = prepare_translateto_worflow(message)
    edit_message :text, text: text, reply_markup: reply_markup
  end

  private

  def translateto_full
    save_context :translateto_send_sentence
    respond_with :message, text: t('common.send_sentence')
  end

  def translateto_direct(sentence)
    reply_markup, text = prepare_translateto_worflow(sentence)
    respond_with :message, text: text, reply_markup: reply_markup
  end

  def prepare_translateto_worflow(sentence)
    text = Translators::YandexWrapper.new(sentence).translate('ru', current_language)
    clean = text.tr('.', ' ').strip
    reply_markup = nil
    if clean.split.one? && !current_user.word?(clean)
      reply_markup = { inline_keyboard: addword_keyboard(clean, :addword) }
    end
    [reply_markup, text]
  end
end
