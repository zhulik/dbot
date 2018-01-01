# frozen_string_literal: true

module KeyboardsHelper
  def languages_inline_keyboard
    Language.select(:name, :slug).map { |l| { text: l.name, callback_data: l.slug } }.each_slice(2).to_a
  end

  def yes_no_inline_keyboard
    [
      [
        { text: t('common.choice_yes'), callback_data: 'yes' },
        { text: t('common.choice_no'), callback_data: 'no' }
      ]
    ]
  end
end
