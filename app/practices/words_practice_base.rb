# frozen_string_literal: true

class WordsPracticeBase < Practice
  def start
    word = Words::WeighedRandom.new(current_user.current_words, self.class.context).get
    return respond_message text: t('dbot.words.no_words_added') if word.nil?
    variants = Words::Variants.new(current_user, word).get
    respond_message text: word_text(word), reply_markup: {
      inline_keyboard: keyboard(word, variants)
    }
  end

  def callback_query(query)
    return respond_message text: t('common.finished') if query == 'finish'
    handle_practice_callback_query(query)
  end

  protected

  def finish_button(ctx)
    { text: t('common.finish'), callback_data: "#{ctx}:finish" }
  end

  def handle_practice_callback_query(query)
    w1, w2 = query.split(':')
    w1 = current_user.words.find(w1)
    w2 = current_user.words.find(w2)
    if w1 == w2 # right answer
      w1.send("#{self.class.context}_success!")
      answer_callback_query t('common.right', word: w1.word, translation: w1.translation)
      return start
    end
    w1.send("#{self.class.context}_fail!")
    w2.send("#{self.class.context}_fail!")
    answer_callback_query t('common.wrong', right_word: w1.word, right_translation: w1.translation,
                                            wrong_word: w2.word, wrong_translation: w2.translation)
    start
  end

  def with_article(word)
    return word.word unless word.noun?
    "#{Constants::ARTICLES[word.gen]} #{word.word.capitalize}"
  end

  private

  def keyboard(word, variants)
    vars = variants.map do |w|
      { text: variant_text(w), callback_data: "#{self.class.practice_context}:#{word.id}:#{w.id}" }
    end
    vars << finish_button(self.class.practice_context)
    vars.each_slice(2).to_a
  end
end
