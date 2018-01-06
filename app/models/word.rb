# frozen_string_literal: true

class Word < ApplicationRecord
  belongs_to :user
  belongs_to :language

  validates :word, :translation, :pos, presence: true
  validates :word, uniqueness: { scope: %i[user_id language_id] }

  paginates_per 20

  enum pos: {
    noun: 'noun',
    verb: 'verb',
    adjective: 'adjective',
    adverb: 'adverb',
    pronoun: 'pronoun',
    preposition: 'preposition',
    conjunction: 'conjunction',
    numeral: 'numeral',
    participle: 'participle'
  }
  enum gen: {
    f: 'f',
    m: 'm',
    n: 'n'
  }

  [:wordsfrom].each do |practice|
    %i[success fail].each do |result|
      define_method "#{practice}_#{result}!" do
        increment!("#{practice}_#{result}")
      end
    end
  end
end
