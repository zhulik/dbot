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

  private

  def translatefrom_full
    save_context :translatefrom_send_sentence
    respond_with :message, text: t('common.send_sentence')
  end

  def translatefrom_direct(sentence)
    text = TRANSLATOR.translate(sentence, from: current_user.language.code, to: 'ru')
    clean = text.tr('.', ' ').strip
    reply_markup = nil
    reply_markup = { inline_keyboard: addword_keyboard(clean) } if clean.split(' ').count == 1
    respond_with :message, text: text, reply_markup: reply_markup
  end
end
