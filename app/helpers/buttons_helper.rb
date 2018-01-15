# frozen_string_literal: true

module ButtonsHelper
  def cancel_button(ctx)
    { text: t('common.cancel'), callback_data: "#{ctx}:cancel" }
  end

  def finish_button(ctx)
    { text: t('common.finish'), callback_data: "#{ctx}:finish" }
  end

  def custom_variant_button(ctx)
    { text: t('common.custom_variant'), callback_data: "#{ctx}:custom_variant" }
  end

  def addword_keyboard(word, ctx)
    [
      [
        { text: t('common.add_word', word: word), callback_data: "#{ctx}:#{word}" },
        cancel_button(ctx)
      ]
    ]
  end
end
