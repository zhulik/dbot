# frozen_string_literal: true

module KeyboardsHelper
  def languages_keyboard
    languages = Language.select(:name, :slug).map do |l|
      {
        text: l.name, callback_data: l.slug
      }
    end.each_slice(2).to_a
    {
      inline_keyboard: languages
    }
  end
end
