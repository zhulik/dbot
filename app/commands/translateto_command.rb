# frozen_string_literal: true

class TranslatetoCommand < TranslateCommandBase
  help -> { I18n.t('dbot.translateto.help') }
  arguments :any

  private

  def context_name
    :translateto_send_sentence
  end

  def translate(sentence)
    Translators::YandexWrapper.new(sentence).translate('ru', current_language)
  end
end
