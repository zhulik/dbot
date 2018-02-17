# frozen_string_literal: true

class WordPresenter
  def initialize(word, translation, pos, gen, lang = nil)
    @word = word
    @translation = translation
    @pos = pos
    @gen = gen
    @lang = lang
  end

  def with_article
    return @word unless @pos == 'noun'
    "#{Constants::ARTICLES[@gen] || 'unk'} #{@word.capitalize}"
  end

  def full_description
    "#{with_article} - #{@translation} #{@pos} #{@gen}"
  end
end
