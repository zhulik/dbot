# frozen_string_literal: true

module KeyboardsHelper
  def languages_inline_keyboard
    Language.select(:name, :code).map { |l| { text: l.name, callback_data: "languages:#{l.code}" } }.each_slice(2).to_a
  end

  def variants_keyboard(variants, ctx)
    keys = variants.map.with_index do |var, index|
      {
        text: "#{var[:word]} - #{var[:translation]} #{var[:pos]} #{var[:gen]}",
        callback_data: "#{ctx}:#{index}"
      }
    end.each_slice(1).to_a
    keys + [[cancel_button(ctx), custom_variant_button(ctx)]]
  end

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

  def message_keyboard(text, translate_context)
    [
      { text: t('.feedback'), callback_data: 'feedback:message' },
      { text: t('.translate'), callback_data: "#{translate_context}:message" },
      { text: t('.pronounce'), callback_data: 'pronounce:message' },
      cancel_button(:message)
    ].tap do |keys|
      clean = text.tr('.', ' ').strip
      keys << { text: t('common.add_word', word: clean), callback_data: "addword:#{clean}" } if clean.split.one?
    end.each_slice(2).to_a
  end

  def pagination_keyboard(scope, ctx)
    [].tap do |keys|
      keys << { text: t('common.prev_page'), callback_data: "#{ctx}:page:#{scope.prev_page}" } unless scope.first_page?
      keys << { text: t('common.next_page'), callback_data: "#{ctx}:page:#{scope.next_page}" } unless scope.last_page?
    end.each_slice(2).to_a
  end

  def practices_keyboard
    [].tap do |keys|
      keys << { text: t('.wordsfrom'), callback_data: 'practice:wordsfrom' }
      keys << { text: t('.wordsto'), callback_data: 'practice:wordsto' }
    end.each_slice(2).to_a
  end

  def wordsfrom_keyboard(word, variants)
    vars = variants.map do |w|
      { text: w.translation, callback_data: "wordsfrom_practice:#{word.id}:#{w.id}" }
    end
    vars << finish_button(:wordsfrom_practice)
    vars.each_slice(2).to_a
  end

  def wordsto_keyboard(word, variants)
    vars = variants.map do |w|
      { text: with_article(w), callback_data: "wordsto_practice:#{word.id}:#{w.id}" }
    end
    vars << finish_button(:wordsto_practice)
    vars.each_slice(2).to_a
  end
end
