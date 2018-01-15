# frozen_string_literal: true

class AddwordCommand < Command
  include ButtonsHelper

  usage -> { I18n.t('dbot.addword.usage') }
  help -> { I18n.t('dbot.assword.help') }
  arguments 0, 1, 3

  def message(*args)
    return respond_message text: self.class.usage if args.count == 2 || args.count > 4
    return respond_message text: t('common.already_added', word: args[0]) if current_user.word?(args[0])
    return addword_full if args.empty?
    return addword_short(args.first) if args.one?
    word = { word: args[0], translation: args[1], pos: args[2], gen: args[3] }
    create_word(word)
  end
  alias send_word message

  def callback_query(query)
    return respond_message text: t('common.canceled') if query == 'cancel'
    variants = prepare_addword_worflow(query)
    respond_message text: t('dbot.addword.choose_right_variant'),
                    reply_markup: { inline_keyboard: variants_keyboard(variants, :addword_choose) }
  end

  def choose_callback_query(query)
    if query == 'custom_variant'
      save_context :addword_custom_variant
      return respond_message text: t('dbot.addword.send_translation')
    end
    variants = session[:addword_variants]
    session.clear
    return respond_message text: t('common.canceled') if query == 'cancel'
    word = variants[query.to_i]
    return respond_message, text: t('common.already_added', word: word[:word]) if current_user.word?(word[:word])
    w = current_user.current_words.create!(word)
    respond_message text: t('dbot.addword.word_added', word: w.word, translation: w.translation)
  end

  def custom_variant(*args)
    save_context :addword_custom_variant
    return respond_message text: self.class.usage if args.count < 2 || args.count > 3
    word = { word: session[:addword_word], translation: args.first, pos: args.second, gen: args.third }
    word[:word], word[:translation] = word[:translation], word[:word] if session.delete(:addword_inverse)
    create_word(word)
  end

  private

  def create_word(w)
    return unknown_pos(w[:pos]) unless Word.pos.keys.include?(w[:pos])
    return unknown_gen(w[:gen]) if w[:gen].present? && !Word.gens.keys.include?(w[:gen])
    return respond_message text: t('common.already_added', word: w[:word]) if current_user.word?(w[:word])
    current_user.current_words.create!(w)
    respond_message text: t('dbot.addword.word_added', w)
    session.clear
  end

  def addword_full
    save_context :addword_send_word
    respond_message text: t('common.send_word')
  end

  def addword_short(word)
    variants = prepare_addword_worflow(word)
    respond_message text: t('dbot.addword.choose_right_variant'),
                    reply_markup: { inline_keyboard: variants_keyboard(variants, :addword_choose) }
  end

  def unknown_gen(gen)
    respond_message text: t('common.unknown_gen', gen: gen, valid: Word.gens.keys.join(', '))
  end

  def unknown_pos(pos)
    respond_message text: t('common.unknown_pos', pos: pos, valid: Word.pos.keys.join(', '))
  end

  def prepare_addword_worflow(word)
    inverse = Translators::YandexWrapper.new(word).detect == 'ru'
    if inverse # If source language is russian use native addword workflow, otherwise user target lang
      Dictionaries::YandexWrapper.new(word, from: 'ru', to: current_language,
                                            inverse: inverse).variants
    else
      Dictionaries::YandexWrapper.new(word, from: current_language, to: 'ru').variants
    end.tap do |variants|
      session[:addword_variants] = variants
      session[:addword_word] = word
      session[:addword_inverse] = inverse
    end
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
end
