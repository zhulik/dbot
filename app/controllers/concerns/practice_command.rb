# frozen_string_literal: true

module PracticeCommand
  def practice(*)
    respond_with :message, text: t('.what_practice'), reply_markup: { inline_keyboard: practices_keyboard }
  end

  def practice_callback_query(type)
    send("start_#{type}_practice")
  end

  def wordsfrom_practice_callback_query(query)
    return edit_message :text, text: t('common.finished') if query == 'finish'
    handle_practice_callback_query(query, :wordsfrom)
  end

  def wordsto_practice_callback_query(query)
    return edit_message :text, text: t('common.finished') if query == 'finish'
    handle_practice_callback_query(query, :wordsto)
  end

  private

  def start_wordsfrom_practice
    word = Words::WeighedRandom.new(current_user.current_words, :wordsfrom).get
    return edit_message :text, text: t('dbot.words.no_words_added') if word.nil?
    variants = Words::Variants.new(current_user, word).get
    edit_message :text, text: with_article(word), reply_markup: {
      inline_keyboard: wordsfrom_keyboard(word, variants)
    }
  end

  def start_wordsto_practice
    word = Words::WeighedRandom.new(current_user.current_words, :wordsto).get
    return edit_message :text, text: t('dbot.words.no_words_added') if word.nil?
    variants = Words::Variants.new(current_user, word).get
    edit_message :text, text: word.translation, reply_markup: {
      inline_keyboard: wordsto_keyboard(word, variants)
    }
  end

  def handle_practice_callback_query(query, type)
    w1, w2 = query.split(':')
    word = current_user.words.find(w1)
    if w1 == w2 # right answer
      word.send("#{type}_success!")
      answer_callback_query t('common.right', word: word.word, translation: word.translation)
      return send("start_#{type}_practice")
    end
    word.send("#{type}_fail!")
    answer_callback_query t('common.wrong', word: word.word, translation: word.translation)
    send("start_#{type}_practice")
  end
end
