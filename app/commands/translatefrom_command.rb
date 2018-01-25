# frozen_string_literal: true

class TranslatefromCommand < TranslateCommandBase
  help -> { I18n.t('dbot.translatefrom.help') }
  arguments :any

  private

  def context_name
    :translatefrom_send_sentence
  end

  def translate(sentence)
    Translators::YandexWrapper.new(sentence).translate(current_language, 'ru')
  end
end
