# frozen_string_literal: true

module LanguagesCommand
  def languages(*)
    return respond_with :message, text: t('.no_languages') if Language.all.empty?
    save_context :languages
    respond_with :message, text: t('.choose_language'), reply_markup: { inline_keyboard: languages_inline_keyboard }
  end

  protected

  def handle_callback_query_action_languages(query)
    language = Language.find_by(code: query)
    return edit_message :text, text: t('.unknown_language', code: query) if language.nil?
    current_user.update_attributes!(language: language)
    edit_message :text, text: t('.language_accepted', name: language.name)
  end
end
