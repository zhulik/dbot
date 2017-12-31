# frozen_string_literal: true

class Language < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :words, dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
end
