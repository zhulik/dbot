# frozen_string_literal: true

class User < ApplicationRecord
  validates :user_id, presence: true, uniqueness: true
  belongs_to :language, optional: true
end
