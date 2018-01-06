# frozen_string_literal: true

require 'open-uri'

class TTS::CachedTTS
  include Rails.application.routes.url_helpers

  def initialize(phrase, language, tts_wrapper = TTS::VoiceRSS)
    @phrase = phrase
    @language = language
    @tts_wrapper = tts_wrapper
  end

  def get(&block)
    return development_get(&block) if Rails.env.development?
    tts = existing
    if tts.nil?
      io = NamedStringIO.new(data, 'voice.ogg')
      tts = @language.tts_phrases.create!(phrase: @phrase, voice: io)
    end
    yield tts.voice.url
  end

  private

  def existing
    @existing ||= @language.tts_phrases.find_by(phrase: @phrase)
  end

  def data
    @data ||= TTS::VoiceRSS.new(@phrase, @language.code).pronounce.force_encoding('BINARY')
  end

  def with_tempfile
    f = Tempfile.new('voice.ogg')
    f.binmode
    yield f
  ensure
    f.close!
  end

  def development_get
    with_tempfile do |f|
      f.write(data)
      f.rewind
      yield f
    end
  end
end
