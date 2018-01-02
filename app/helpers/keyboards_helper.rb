# frozen_string_literal: true

module KeyboardsHelper
  def languages_inline_keyboard
    Language.select(:name, :code).map { |l| { text: l.name, callback_data: l.code } }.each_slice(2).to_a
  end

  def yes_no_inline_keyboard
    [
      [
        { text: t('common.choice_yes'), callback_data: 'yes' },
        { text: t('common.choice_no'), callback_data: 'no' },
        { text: t('common.cancel'), callback_data: 'cancel' }
      ]
    ]
  end
end
