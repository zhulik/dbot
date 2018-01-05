# frozen_string_literal: true

module WordsHelper
  ARTICLES = {
    'f' => 'die',
    'm' => 'der',
    'n' => 'das',
    nil: 'unk'
  }.freeze

  def with_article(word)
    return word.word unless word.noun?
    "#{ARTICLES[word.gen]} #{word.word.capitalize}"
  end
end
