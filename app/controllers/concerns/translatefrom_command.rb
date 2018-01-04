# frozen_string_literal: true

module TranslatefromCommand
  extend ActiveSupport::Concern

  included do
    context_handler :translatefrom_send_sentence do |*ws|
      translatefrom_direct(ws.join(' '))
    end
  end

  def translatefrom(*ws)
    return translatefrom_full if ws.empty?
    translatefrom_direct(ws.join(' '))
  end

  def translatefrom_callback_query(_query)
    message = session.delete(:message_to_handle)
    reply_markup, text = prepare_translatefrom_workflow(message)
    edit_message :text, text: text, reply_markup: reply_markup
  end

  private

  def translatefrom_full
    save_context :translatefrom_send_sentence
    respond_with :message, text: t('common.send_sentence')
  end

  def translatefrom_direct(sentence)
    reply_markup, text = prepare_translatefrom_workflow(sentence)
    respond_with :message, text: text, reply_markup: reply_markup
  end

  def prepare_translatefrom_workflow(sentence)
    text = Translators::YandexWrapper.new(sentence).translate(current_language, 'ru')
    clean = text.tr('.', ' ').strip
    reply_markup = nil
    if clean.split.count == 1 && !current_user.word?(clean)
      reply_markup = { inline_keyboard: addword_keyboard(clean, 'addword') }
    end
    [reply_markup, text]
  end
end
