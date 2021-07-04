# frozen_string_literal: true

class TTS::VoiceRSS < TTS::Wrapper
  LANGS = {
    'de' => 'de-de',
    'ru' => 'ru-ru',
    'en' => 'en-us'
  }.freeze

  def pronounce
    VoiceRSS.speech(
      'key' => ENV.fetch('VOICERSS_TOKEN'),
      'hl' => LANGS[@language],
      'src' => @phrase,
      'r' => '-5',
      'c' => 'ogg',
      'f' => '44khz_16bit_stereo',
      'ssml' => 'false',
      'b64' => 'false'
    )['response']
  end
end
