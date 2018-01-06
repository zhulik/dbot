# frozen_string_literal: true

module PracticeCommand
  def practice(*)
    respond_with :message, text: t('.what_practice'), reply_markup: { inline_keyboard: practices_keyboard }
  end

  def practice_callback_query(type)
    send("start_#{type}_practice")
  end

  def wordsfrom_practice_callback_query(query)
    return edit_message :text, text: t('common.canceled') if query == 'cancel'
    w1, w2 = query.split(':')
    word = current_user.words.find(w1)
    if w1 == w2 # right answer
      word.send('wordsfrom_success!')
      answer_callback_query t('common.right', word: word.word, translation: word.translation)
      return start_wordsfrom_practice
    end
    word.send('wordsfrom_fail!')
    answer_callback_query t('common.wrong', word: word.word, translation: word.translation)
    start_wordsfrom_practice
  end

  private

  def start_wordsfrom_practice
    word = Words::WeighedRandom.new(current_user.words, :wordsfrom).get
    return edit_message :text, text: t('dbot.words.no_words_added') if word.nil?
    edit_message :text, text: with_article(word), reply_markup: {
      inline_keyboard: transations_keyboard(word, :wordsfrom_practice)
    }
  end
end
