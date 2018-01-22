# frozen_string_literal: true

class WordsPracticeBase < Practice
  protected

  def start
    word = random_word
    return respond_message text: t('dbot.words.no_words_added') if word.nil?
    variants = Words::Variants.new(current_user, word).get
    respond_message text: word_text(word), reply_markup: {
      inline_keyboard: keyboard(word, variants)
    }
  end

  def callback_query(query)
    w1, w2 = query.split(':')
    w1 = current_user.words.find(w1)
    w2 = current_user.words.find(w2)
    answer = if w1 == w2 # right answer
               inc_stat(w1)
               t('common.right', word: w1.word, translation: w1.translation)
             else
               dec_stat(w1, w2)
               t('common.wrong', right_word: w1.word, right_translation: w1.translation,
                                 wrong_word: w2.word, wrong_translation: w2.translation)
             end
    answer_callback_query answer
    start
  end

  private

  def dec_stat(w1, w2)
    w1.inc_stat!("#{self.class.context}_fail")
    w2.inc_stat!("#{self.class.context}_fail")
    update_stat(w1.id, :fail)
  end

  def inc_stat(w1)
    w1.inc_stat!("#{self.class.context}_success")
    update_stat(w1.id, :success)
  end

  def keyboard(word, variants)
    vars = variants.map do |w|
      { text: variant_text(w), callback_data: "#{self.class.practice_context}:#{word.id}:#{w.id}" }
    end
    vars << finish_button(self.class.practice_context)
    vars.each_slice(2).to_a
  end
end
