# frozen_string_literal: true

class TtsPhrase < ApplicationRecord
  belongs_to :language
  mount_uploader :voice, TtsUploader

  validates :phrase, presence: true, uniqueness: { scope: [:language_id] }
  validates :voice, presence: true
end
