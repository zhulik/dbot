# frozen_string_literal: true

class TTS::Wrapper
  def initialize(phrase, language)
    @phrase = phrase
    @language = language
  end

  # Subclasses should implement this method and return binary data with mp3
  def pronounce
    #:nocov:
    raise NotImplementedError
    #:nocov:
  end
end
