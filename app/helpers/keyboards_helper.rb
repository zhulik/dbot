# frozen_string_literal: true

module KeyboardsHelper
  def languages_inline_keyboard
    Language.select(:name, :code).map { |l| { text: l.name, callback_data: "languages:#{l.code}" } }.each_slice(2).to_a
  end

  def variants_keyboard(variants, context)
    keys = variants.map.with_index do |var, index|
      {
        text: "#{var[:translation]} #{var[:pos]} #{var[:gen]}",
        callback_data: "#{context}:#{index}"
      }
    end.each_slice(1).to_a
    keys + [[cancel_button(context), custom_variant_button(context)]]
  end

  def yes_no_inline_keyboard(context)
    [
      [
        { text: t('common.choice_yes'), callback_data: 'yes' },
        { text: t('common.choice_no'), callback_data: 'no' },
        cancel_button(context)
      ]
    ]
  end

  def cancel_button(context)
    { text: t('common.cancel'), callback_data: "#{context}:cancel" }
  end

  def custom_variant_button(context)
    { text: t('common.custom_variant'), callback_data: "#{context}:custom_variant" }
  end
end
