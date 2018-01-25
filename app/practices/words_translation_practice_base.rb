# frozen_string_literal: true

class WordsTranslationPracticeBase < WordsPracticeBase
  protected

  def valid_answer?(word1, word2)
    word1 = current_user.words.find(word1)
    word2 = current_user.words.find(word2)
    [word1 == word2, word1, word2]
  end

  def success_answer(word1, _word2)
    t('common.right', word: word1.word, translation: word1.translation)
  end

  def fail_answer(word1, word2)
    t('common.wrong', right_word: word1.word, right_translation: word1.translation,
                      wrong_word: word2.word, wrong_translation: word2.translation)
  end

  private

  def keyboard(word)
    variants = Words::Variants.new(current_user, word).get
    vars = variants.map do |w|
      { text: variant_text(w), callback_data: "#{self.class.practice_context}:#{word.id}:#{w.id}" }
    end
    vars << finish_button(self.class.practice_context)
    vars.each_slice(2).to_a
  end
end
