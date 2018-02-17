# frozen_string_literal: true

class WordstoPractice < WordsTranslationPracticeBase
  practice_name -> { I18n.t('dbot.practice.wordsto') }

  private

  def word_text(word)
    word.translation
  end

  def variant_text(w)
    with_article(w)
  end
end
