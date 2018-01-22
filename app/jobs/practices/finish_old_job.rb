# frozen_string_literal: true

class Practices::FinishOldJob < ApplicationJob
  def perform
    old_stats = PracticeStat.in_progress.where('updated_at < :time', time: Time.zone.now - 5.minutes)
    old_stats.find_each do |stat|
      Practices::Finish.call(Telegram.bots[:default], stat)
    end
  end
end
