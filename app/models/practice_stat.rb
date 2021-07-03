# frozen_string_literal: true

class PracticeStat < ApplicationRecord
  belongs_to :user

  validates :practice, :message_id, :chat_id, :status, presence: true
  validates :message_id, uniqueness: { scope: :chat_id }

  validates :chat_id, uniqueness: { conditions: -> { in_progress } } # rubocop: disable Rails/UniqueValidationWithoutIndex
  serialize :stats, StatsHashSerializer

  enum status: {
    in_progress: 'in_progress',
    finished: 'finished'
  }
end
