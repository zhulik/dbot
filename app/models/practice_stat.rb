# frozen_string_literal: true

class PracticeStat < ApplicationRecord
  belongs_to :user

  validates :practice, :message_id, :chat_id, :status, presence: true
  validates :message_id, uniqueness: { scope: :chat_id }

  validates :user_id, uniqueness: { condition: -> { in_progress } }
  serialize :stats, DefaultHashSerializer

  enum status: {
    in_progress: 'in_progress',
    finished: 'finished'
  }

  def inc_stat!(name)
    stats[name] += 1
    save!
  end
end
