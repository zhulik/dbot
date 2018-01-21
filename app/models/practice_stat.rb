# frozen_string_literal: true

class PracticeStat < ApplicationRecord
  belongs_to :user

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
