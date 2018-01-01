# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :language, optional: true
  has_many :words, dependent: :destroy

  validates :user_id, presence: true, uniqueness: true

  def current_words
    words.where(language_id: language_id)
  end

  def word?(word)
    current_words.find_by(word: word)
  end
end
