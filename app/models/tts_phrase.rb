# frozen_string_literal: true

class TtsPhrase < ApplicationRecord
  belongs_to :language
  has_one_attached :voice

  validates :phrase, presence: true, uniqueness: { scope: [:language_id] }
end
