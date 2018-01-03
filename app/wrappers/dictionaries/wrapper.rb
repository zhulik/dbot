# frozen_string_literal: true

class Dictionaries::Wrapper
  def initialize(word, from:, to:)
    @word = word
    @from = from
    @to = to
  end

  # Subclasses should implement this method and return array of length 4 or less with translation variants like
  # [
  #   {
  #     word: 'word',
  #     translation: 'translation',
  #     gen: 'm', # if possible
  #     pos: 'verb'
  #   }
  # ]
  def variants
    raise NotImplementedError
  end

  # Subclasses should implement this method and return raw dictionary output
  def raw
    raise NotImplementedError
  end
end
