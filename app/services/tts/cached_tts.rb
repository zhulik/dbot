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
      tts = @language.tts_phrases.create!(phrase: @phrase)
      tts.voice.attach(io: StringIO.open(data), filename: 'voice.ogg', content_type: 'audio/ogg')
    end
    yield rails_blob_url(tts.voice, disposition: 'attachment', host: 'https://dbot.lighty.photo')
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
