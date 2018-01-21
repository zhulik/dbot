# frozen_string_literal: true

class WordstoPractice < WordsPracticeBase
  practice_name -> { I18n.t('dbot.practice.wordsto') }

  protected

  def word_text(word)
    word.translation
  end

  def variant_text(w)
    with_article(w)
  end
end
