# frozen_string_literal: true

class Word < ApplicationRecord
  include WordAdmin
  belongs_to :user
  belongs_to :language

  validates :word, :translation, :pos, presence: true
  validates :word, uniqueness: { scope: %i[user_id language_id] }
  # TODO: validate gen presence for nouns and nil gen for others
  # TODO: rework uniqueness validation

  paginates_per 20

  serialize :practice_stats, DefaultHashSerializer.new { 0 }

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

  def inc_stat!(name)
    practice_stats[name] += 1
    save!
  end
end
