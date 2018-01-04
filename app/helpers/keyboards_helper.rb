# frozen_string_literal: true

module KeyboardsHelper
  def languages_inline_keyboard
    Language.select(:name, :code).map { |l| { text: l.name, callback_data: "languages:#{l.code}" } }.each_slice(2).to_a
  end

  def variants_keyboard(variants, context)
    keys = variants.map.with_index do |var, index|
      {
        text: "#{var[:word]} - #{var[:translation]} #{var[:pos]} #{var[:gen]}",
        callback_data: "#{context}:#{index}"
      }
    end.each_slice(1).to_a
    keys + [[cancel_button(context), custom_variant_button(context)]]
  end

  def cancel_button(context)
    { text: t('common.cancel'), callback_data: "#{context}:cancel" }
  end

  def custom_variant_button(context)
    { text: t('common.custom_variant'), callback_data: "#{context}:custom_variant" }
  end

  def addword_keyboard(word, context)
    [
      [
        { text: t('common.add_word', word: word), callback_data: "#{context}:#{word}" },
        cancel_button(context)
      ]
    ]
  end

  def message_keyboard(text, translate_context)
    [
      { text: t('.feedback'), callback_data: 'feedback:message' },
      { text: t('.translate'), callback_data: "#{translate_context}:message" },
      { text: t('.pronounce'), callback_data: 'pronounce:message' },
      cancel_button(:message)
    ].tap do |keys|
      clean = text.tr('.', ' ').strip
      keys << { text: t('common.add_word', word: clean), callback_data: "addword:#{clean}" } if clean.split.length == 1
    end.each_slice(2).to_a
  end
end
