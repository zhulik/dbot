# frozen_string_literal: true

class Word < ApplicationRecord
  include WordAdmin
  belongs_to :user
  belongs_to :language

  validates :word, :translation, :pos, presence: true
  validates :word, uniqueness: { scope: %i[user_id language_id] }
  # TODO: validate gen presence for nouns and nil gen for others
  # TODO: rework work uniqueness validation

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

  %i[wordsfrom wordsto articles].each do |practice|
    %i[success fail].each do |result|
      define_method "#{practice}_#{result}!" do
        update_attributes!("#{practice}_#{result}" => send("#{practice}_#{result}") + 1)
      end
    end
  end
end
