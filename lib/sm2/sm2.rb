# frozen_string_literal: true

class SM2::SM2
  def initialize(quality_response, prev_interval = 0, prev_ef = 2.5)
    @prev_ef = prev_ef
    @prev_interval = prev_interval
    @quality_response = quality_response

    @calculated_interval = nil
    @calculated_ef = nil
    @repetition_date = nil

    # if quality_response is below 3 start repetition from the begining, but without changing easiness_factor
    if @quality_response < 3

      @calculated_ef = @prev_ef
      @calculated_interval = 0
    else
      calculate_easiness_factor
      calculate_interval
    end
    calculate_date
  end

  def interval
    @calculated_interval
  end

  def easiness_factor
    @calculated_ef.round(2)
  end

  def next_repetition_date
    @repetition_date
  end

  private

  def calculate_interval
    @calculated_interval = if @prev_interval.zero?
                             1
                           elsif @prev_interval == 1
                             6
                           else
                             (@prev_interval * @prev_ef).to_i
                           end
  end

  def calculate_easiness_factor
    @calculated_ef = @prev_ef + (0.1 - (5 - @quality_response) * (0.08 + (5 - @quality_response) * 0.02))
    @calculated_ef = 1.3 if @calculated_ef < 1.3
    @calculated_ef.round(2)
  end

  def calculate_date
    @repetition_date = Date.today + @calculated_interval
  end
end
