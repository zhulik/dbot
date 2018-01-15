# frozen_string_literal: true

class LanguagesCommand < Command
  usage -> { I18n.t('dbot.languages.usage') }
  help -> { I18n.t('dbot.languages.help') }
  arguments 0

  def message_0
    return respond_message text: t('dbot.languages.no_languages') if Language.all.empty?
    respond_message text: t('dbot.languages.choose_language'), reply_markup: {
      inline_keyboard: languages_inline_keyboard
    }
  end

  def callback_query(query)
    language = Language.find_by(code: query)
    return answer_callback_query t('dbot.languages.unknown_language', code: query) if language.nil?
    current_user.update_attributes!(language: language)
    answer_callback_query t('dbot.languages.language_accepted', name: language.name)
  end

  private

  def languages_inline_keyboard
    Language.select(:name, :code).map { |l| { text: l.name, callback_data: "languages:#{l.code}" } }.each_slice(2).to_a
  end
end
