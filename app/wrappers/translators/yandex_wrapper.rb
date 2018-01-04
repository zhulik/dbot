# frozen_string_literal: true

class Translators::YandexWrapper < Translators::Wrapper
  TRANSLATOR = Yandex::Translator.new(Rails.application.secrets.yandex_translator)

  def translate(from, to)
    @translation ||= TRANSLATOR.translate(@text, from: from, to: to)
  end

  def detect
    @detected ||= TRANSLATOR.detect(@text)
  end
end
