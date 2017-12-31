# frozen_string_literal: true

class Word < ApplicationRecord
  belongs_to :user
  belongs_to :language

  validates :word, :translation, presence: true
  validates :word, uniqueness: { scope: %i[user_id language_id] }
end
