# frozen_string_literal: true

class SM2::SM2
  MIN_EF = 1.3

  INTERVALS = {
    0 => 1,
    1 => 6
  }.freeze

  attr_reader :interval, :next_repetition_date, :easiness_factor

  def initialize(quality_response, prev_interval = 0, prev_ef = 2.5)
    if quality_response < 3
      @easiness_factor = prev_ef
      @interval = 0
    else
      @easiness_factor = new_easiness_factor(quality_response, prev_ef)
      @interval = INTERVALS[prev_interval] || (prev_interval * prev_ef).to_i
    end
    @next_repetition_date = Date.today + @interval
  end

  private

  def new_easiness_factor(quality_response, prev_ef)
    (prev_ef + (0.1 - (5 - quality_response) * (0.08 + (5 - quality_response) * 0.02))).round(2).tap do |factor|
      return MIN_EF if factor < MIN_EF
    end
  end
end
