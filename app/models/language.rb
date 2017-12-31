# frozen_string_literal: true

class Language < ApplicationRecord
  has_many :users, dependent: :nullify

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
end
