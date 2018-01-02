# frozen_string_literal: true

class Language < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :words, dependent: :destroy

  validates :name, :code, presence: true
  validates :code, uniqueness: true
end
