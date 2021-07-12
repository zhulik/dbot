# frozen_string_literal: true

require 'open-uri'

class TTS::CachedTTS
  include Rails.application.routes.url_helpers

  def initialize(phrase, language, tts_wrapper = TTS::VoiceRSS)
    @phrase = phrase
    @language = language
    @tts_wrapper = tts_wrapper
  end

  def get
    tts = existing
    return yield tts.voice.url if tts.present?

    with_tempfile do |f|
      f.write(data)
      f.rewind
      io = NamedStringIO.new(f.read, 'voice.ogg')
      tts = @language.tts_phrases.create!(phrase: @phrase, voice: io)
      f.rewind
      yield f
    end
  end

  private

  def existing
    @existing ||= @language.tts_phrases.find_by(phrase: @phrase)
  end

  def data
    @data ||= TTS::OggConverter.new.convert(@tts_wrapper.new(@phrase, @language.code).pronounce)
  end

  def with_tempfile
    f = Tempfile.new('voice.ogg')
    f.binmode
    yield f
  ensure
    f.close!
  end
end
