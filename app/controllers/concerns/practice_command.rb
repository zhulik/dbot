# frozen_string_literal: true

module PracticeCommand
  def practice(*)
    respond_with :message, text: t('.what_practice'), reply_markup: { inline_keyboard: practices_keyboard }
  end

  def practice_callback_query(type)
    send("start_#{type}_practice")
  end

  def words_practice_callback_query(query)
    return edit_message :text, text: t('common.canceled') if query == 'cancel'
    w1, w2 = query.split(':')
    word = current_user.words.find(w1)
    if w1 == w2 # right answer
      answer_callback_query t('common.right', word: word.word, translation: word.translation)
      return start_words_practice
    end
    answer_callback_query t('common.wrong', word: word.word, translation: word.translation)
    start_words_practice
  end

  private

  def start_words_practice
    word = current_user.words.order('RANDOM()').first
    edit_message :text, text: word.word, reply_markup: { inline_keyboard: transations_keyboard(word, :words_practice) }
  end
end
