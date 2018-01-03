# frozen_string_literal: true

TRANSLATOR = Yandex::Translator.new(Rails.application.secrets.yandex_translator)
Yandex::Dictionary.api_key = Rails.application.secrets.yandex_dictionary
