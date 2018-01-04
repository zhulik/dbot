# frozen_string_literal: true

module AddwordCommand
  extend ActiveSupport::Concern

  included do
    context_handler :addword_send_word do |*ws|
      addword_short(ws.first)
    end

    context_handler :addword_custom_variant do |*ws|
      save_context :addword_custom_variant
      return respond_with :message, text: t('.usage') if ws.count < 2 || ws.count > 3
      word = { word: session[:addword_word], translation: ws.first, pos: ws.second, gen: ws.third }
      word[:word], word[:translation] = word[:translation], word[:word] if session.delete(:addword_inverse)
      create_word(word)
    end
  end

  def addword(*ws)
    return respond_with :message, text: t('.usage') if ws.count == 2 || ws.count > 4
    return respond_with :message, text: t('common.already_added', word: ws[0]) if current_user.word?(ws[0])
    return addword_full if ws.empty?
    return addword_short(ws.first) if ws.count == 1
    addword_direct(ws)
  end

  def addword_choose_callback_query(query)
    if query == 'custom_variant'
      save_context :addword_custom_variant
      return edit_message :text, text: t('dbot.addword.send_translation')
    end
    variants = session[:addword_variants]
    session.clear
    return edit_message :text, text: t('common.canceled') if query == 'cancel'
    word = variants[query.to_i]
    return edit_message :text, text: t('common.already_added', word: word[:word]) if current_user.word?(word[:word])
    w = current_user.current_words.create!(word)
    edit_message :text, text: t('dbot.addword.word_added', word: w.word, translation: w.translation)
  end

  def addword_callback_query(query)
    return edit_message :text, text: t('common.canceled') if query == 'cancel'
    variants = prepare_addword_worflow(query)
    edit_message :text, text: t('dbot.addword.choose_right_variant'),
                        reply_markup: { inline_keyboard: variants_keyboard(variants, :addword_choose) }
  end

  private

  def addword_direct(ws)
    word = { word: ws[0], translation: ws[1], pos: ws[2], gen: ws[3] }
    create_word(word)
  end

  def create_word(w)
    return unknown_pos(w[:pos]) unless Word.pos.keys.include?(w[:pos])
    return unknown_gen(w[:gen]) if w[:gen].present? && !Word.gens.keys.include?(w[:gen])
    return respond_with :message, text: t('common.already_added', word: w[:word]) if current_user.word?(w[:word])
    current_user.current_words.create!(w)
    respond_with :message, text: t('dbot.addword.word_added', w)
    session.clear
  end

  def addword_full
    save_context :addword_send_word
    respond_with :message, text: t('common.send_word')
  end

  def addword_short(word)
    variants = prepare_addword_worflow(word)
    respond_with :message, text: t('dbot.addword.choose_right_variant'),
                           reply_markup: { inline_keyboard: variants_keyboard(variants, :addword_choose) }
  end

  def prepare_addword_worflow(word)
    inverse = Translators::YandexWrapper.new(word).detect == 'ru'
    variants = if inverse # If source language is russian use native addword workflow, otherwise user target lang
                 Dictionaries::YandexWrapper.new(word, from: 'ru', to: current_language,
                                                       inverse: inverse).variants
               else
                 Dictionaries::YandexWrapper.new(word, from: current_language, to: 'ru').variants
               end
    session[:addword_variants] = variants
    session[:addword_word] = word
    session[:addword_inverse] = inverse
    variants
  end

  def unknown_gen(gen)
    respond_with :message, text: t('common.unknown_gen', gen: gen, valid: Word.gens.keys.join(', '))
  end

  def unknown_pos(pos)
    respond_with :message, text: t('common.unknown_pos', pos: pos, valid: Word.pos.keys.join(', '))
  end
end
