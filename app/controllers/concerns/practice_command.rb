# frozen_string_literal: true

module PracticeCommand
  def practice(*)
    respond_message text: t('.what_practice'), reply_markup: { inline_keyboard: practices_keyboard }
  end

  def practice_callback_query(type)
    send("start_#{type}_practice")
  end

  def wordsfrom_practice_callback_query(query)
    return respond_message text: t('common.finished') if query == 'finish'
    handle_practice_callback_query(query, :wordsfrom)
  end

  def wordsto_practice_callback_query(query)
    return respond_message text: t('common.finished') if query == 'finish'
    handle_practice_callback_query(query, :wordsto)
  end

  private

  def start_wordsfrom_practice
    word = Words::WeighedRandom.new(current_user.current_words, :wordsfrom).get
    return respond_message text: t('dbot.words.no_words_added') if word.nil?
    variants = Words::Variants.new(current_user, word).get
    respond_message text: with_article(word), reply_markup: {
      inline_keyboard: wordsfrom_keyboard(word, variants)
    }
  end

  def start_wordsto_practice
    word = Words::WeighedRandom.new(current_user.current_words, :wordsto).get
    return respond_message text: t('dbot.words.no_words_added') if word.nil?
    variants = Words::Variants.new(current_user, word).get
    respond_message text: word.translation, reply_markup: {
      inline_keyboard: wordsto_keyboard(word, variants)
    }
  end

  def handle_practice_callback_query(query, type)
    w1, w2 = query.split(':')
    w1 = current_user.words.find(w1)
    w2 = current_user.words.find(w2)
    if w1 == w2 # right answer
      w1.send("#{type}_success!")
      answer_callback_query t('common.right', word: w1.word, translation: w1.translation)
      return send("start_#{type}_practice")
    end
    w1.send("#{type}_fail!")
    w2.send("#{type}_fail!")
    answer_callback_query t('common.wrong', right_word: w1.word, right_translation: w1.translation,
                                            wrong_word: w2.word, wrong_translation: w2.translation)
    send("start_#{type}_practice")
  end
end
