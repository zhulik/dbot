# frozen_string_literal: true

module KeyboardsHelper
  def languages_inline_keyboard
    languages = Language.select(:name, :slug).map do |l|
      {
        text: l.name, callback_data: { a: :language, s: l.slug }.to_json
      }
    end.each_slice(2).to_a
    {
      inline_keyboard: languages
    }
  end

  def yes_no_inline_keyboard(word, translation)
    yes = {
      text: t('common.choice_yes'),
      callback_data: { a: :word_confirmation, c: 'yes', w: word, t: translation }.to_json
    }
    no = {
      text: t('common.choice_no'),
      callback_data: { a: :word_confirmation, c: 'no', w: word, t: translation }.to_json
    }

    {
      inline_keyboard: [[yes, no]]
    }
  end
end
