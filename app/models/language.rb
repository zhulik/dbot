# frozen_string_literal: true

class Language < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :words, dependent: :destroy

  validates :name, :code, presence: true
  validates :code, uniqueness: true, length: { minimum: 2, maximum: 2 }
  validates :code, iso_639_1: true

  def full_code
    @full_code ||= LanguageList::LanguageInfo.find(code).iso_639_3
  end
end
