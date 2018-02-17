# frozen_string_literal: true

class WordsfromPractice < WordsTranslationPracticeBase
  practice_name -> { I18n.t('dbot.practice.wordsfrom') }

  private

  def word_text(word)
    with_article(word)
  end

  def variant_text(w)
    w.translation
  end
end
