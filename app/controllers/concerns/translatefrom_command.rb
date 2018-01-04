# frozen_string_literal: true

module TranslatefromCommand
  extend ActiveSupport::Concern

  included do
    context_handler :translatefrom_send_sentence do |*ws|
      respond_with :message, text: TRANSLATOR.translate(ws.join(' '), from: current_user.language.code, to: 'ru')
    end
  end

  def translatefrom(*ws)
    return respond_with :message, text: t('common.select_language') if current_user.language.nil?
    return translatefrom_full if ws.empty?
    translatefrom_direct(ws.join(' '))
  end

  private

  def translatefrom_full
    save_context :translatefrom_send_sentence
    respond_with :message, text: t('common.send_sentence')
  end

  def translatefrom_direct(sentence)
    respond_with :message, text: TRANSLATOR.translate(sentence, from: current_user.language.code, to: 'ru')
  end
end
