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
      create_word(word)
    end
  end

  def addword(*ws)
    return respond_with :message, text: t('.usage') if ws.count == 2 || ws.count > 4
    return respond_with :message, text: t('.already_added', word: ws.first) if current_user.word?(ws.first).present?
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
    w = current_user.current_words.create!(variants[query.to_i])
    edit_message :text, text: t('dbot.addword.word_added', word: w.word, translation: w.translation)
  end

  private

  def addword_direct(ws)
    word = { word: ws[0], translation: ws[1], pos: ws[2], gen: ws[3] }
    create_word(word)
  end

  def create_word(word)
    return unknown_pos(word[:pos]) unless Word.pos.keys.include?(word[:pos])
    return unknown_gen(word[:gen]) if word[:gen].present? && !Word.gens.keys.include?(word[:gen])
    current_user.current_words.create!(word)
    respond_with :message, text: t('dbot.addword.word_added', word)
    session.clear
  end

  def addword_full
    save_context :addword_send_word
    respond_with :message, text: t('.send_word')
  end

  def addword_short(word)
    variants = Dictionaries::YandexWrapper.new(word, from: current_user.language.code, to: 'ru').variants
    session[:addword_variants] = variants
    session[:addword_word] = word
    respond_with :message, text: t('dbot.addword.choose_right_variant'),
                           reply_markup: { inline_keyboard: variants_keyboard(variants, :addword_choose) }
  end

  def unknown_gen(gen)
    respond_with :message, text: t('common.unknown_gen', gen: gen, valid: Word.gens.keys.join(', '))
  end

  def unknown_pos(pos)
    respond_with :message, text: t('common.unknown_pos', pos: pos, valid: Word.pos.keys.join(', '))
  end
end
