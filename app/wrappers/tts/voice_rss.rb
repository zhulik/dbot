# frozen_string_literal: true

class TTS::VoiceRSS < TTS::Wrapper
  LANGS = {
    'de' => 'de-de',
    'ru' => 'ru-ru',
    'en' => 'en-us'
  }.freeze

  def pronounce
    VoiceRSS.speech(
      'key' => Rails.application.secrets.voicerss,
      'hl' => LANGS[@language],
      'src' => @phrase,
      'r' => '0',
      'c' => 'ogg',
      'f' => '24khz_8bit_mono',
      'ssml' => 'false',
      'b64' => 'false'
    )['response']
  end
end
