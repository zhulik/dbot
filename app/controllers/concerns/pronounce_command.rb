# frozen_string_literal: true

module PronounceCommand
  extend ActiveSupport::Concern

  included do
    context_handler :pronounce_send_sentence do |*ws|
      pronounce_direct(ws.join(' '))
    end
  end

  def pronounce(*ws)
    return pronounce_full if ws.empty?
    pronounce_direct(ws.join(' '))
  end

  private

  def pronounce_full
    save_context :pronounce_send_sentence
    respond_message text: t('common.send_sentence')
  end

  def pronounce_direct(phrase)
    TTS::CachedTTS.new(phrase, current_user.language).get do |payload|
      respond_with :voice, voice: payload
    end
  end
end
