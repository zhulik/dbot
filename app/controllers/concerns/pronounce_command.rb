# frozen_string_literal: true

module PronounceCommand
  extend ActiveSupport::Concern

  def pronounce(*ws)
    phrase = ws.join(' ')
    TTS::CachedTTS.new(phrase, current_user.language).get do |payload|
      respond_with :voice, voice: payload
    end
  end
end
