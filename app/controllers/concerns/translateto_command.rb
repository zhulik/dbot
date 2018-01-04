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

  private

  def translateto_full
    save_context :translateto_send_sentence
    respond_with :message, text: t('common.send_sentence')
  end

  def translateto_direct(sentence)
    respond_with :message, text: TRANSLATOR.translate(sentence, from: 'ru', to: current_user.language.code)
  end
end
