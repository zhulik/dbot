# frozen_string_literal: true

module MessageHandler
  extend ActiveSupport::Concern

  def message(*)
    return handle_text if payload.text.present?
    respond_with :message, text: t('common.i_dont_understand')
  end

  private

  def handle_text
    lang = Translators::YandexWrapper.new(payload.text).detect
    unless language_supported?(lang) # rubocop:disable Style/GuardClause
      return respond_with :message, text: t('common.unknown_language', lang: lang, current: current_language)
    end
    # response with keyboard
    # if it's native lang - ask to translate or addword or feedback
    # if it's current language - ask to translate or addword or feedback
    # if it's only one word - ask to addword, or translate, or feedback
    # it it's sentence - ask to translate or feedback
  end
end
