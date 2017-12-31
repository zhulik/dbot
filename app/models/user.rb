# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :language, optional: true
  has_many :words, dependent: :destroy

  validates :user_id, presence: true, uniqueness: true
end
