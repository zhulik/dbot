# frozen_string_literal: true

module LanguagesCommand
  def languages(*)
    return respond_message text: t('.no_languages') if Language.all.empty?
    respond_message text: t('.choose_language'), reply_markup: { inline_keyboard: languages_inline_keyboard }
  end

  def languages_callback_query(query)
    language = Language.find_by(code: query)
    return answer_callback_query t('dbot.languages.unknown_language', code: query) if language.nil?
    current_user.update_attributes!(language: language)
    answer_callback_query t('dbot.languages.language_accepted', name: language.name)
  end
end
