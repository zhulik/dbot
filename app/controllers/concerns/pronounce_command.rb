# frozen_string_literal: true

module PronounceCommand
  extend ActiveSupport::Concern

  def pronounce(*ws)
    with_tempfile do |f|
      data = TTS::VoiceRSS.new(ws.join(' '), current_language).pronounce.force_encoding('BINARY')

      f.write(data)
      f.rewind
      respond_with :voice, voice: f

      return
    end
  end

  private

  def with_tempfile
    f = Tempfile.new('voice.ogg')
    f.binmode
    yield f
  ensure
    f.close!
  end
end
