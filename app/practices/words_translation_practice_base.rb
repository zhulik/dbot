# frozen_string_literal: true

class WordsTranslationPracticeBase < WordsPracticeBase
  private

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

  def keyboard(word)
    InlineKeyboard.render do |k|
      k.columns 2
      Words::Variants.new(current_user, word).get.map do |w|
        k.button variant_text(w), self.class.practice_context, word.id, w.id
      end
      k.button InlineKeyboard::Buttons.finish(self.class.practice_context)
    end
  end
end
