# frozen_string_literal: true

class User < ApplicationRecord
  include UserAdmin
  belongs_to :language, optional: true
  has_many :words, dependent: :destroy

  validates :user_id, presence: true, uniqueness: true

  def user_link
    "https://t.me/#{username}"
  end

  def current_words
    words.where(language_id: language_id)
  end

  def word?(word)
    current_words.find_by(word: word).present?
  end
end
