# frozen_string_literal: true

class WordsfromPractice < WordsPracticeBase
  practice_name -> { I18n.t('dbot.practice.wordsfrom') }

  protected

  def word_text(word)
    with_article(word)
  end

  def variant_text(w)
    w.translation
  end
end
