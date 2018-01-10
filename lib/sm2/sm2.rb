# frozen_string_literal: true

# modified sm2 algorithm
# changes:
# - initial interval depends on given quality_response
# - states (easiness_factor is calulated using that states, sm2 for ok uses 4)
#   - 0 - bad (0, -0.8), 1 - so so(2, -0.3), 2 - ok(4, 0), 3 - more than better(5, 0.1)

class SM2::SM2
  attr_reader :interval, :easiness_factor, :next_repetition_date

  def initialize(quality_response, prev_interval = 0, prev_ef = 2.5)
    @prev_ef = prev_ef
    @prev_interval = prev_interval
    @quality_response = quality_response

    @interval = nil
    @easiness_factor = nil
    @next_repetition_date = nil

    # if quality_response is below 3 start repetition from the beginning, but without changing easiness_factor
    if @quality_response < 2
      @interval = 0
      @easiness_factor = @prev_ef
    else
      calculate_easiness_factor!
      calculate_interval!
    end

    @next_repetition_date = Date.today + @interval
  end

  private

  def calculate_interval!
    if @prev_interval.zero?
      @interval = 1
      @interval = 6 if @quality_response == 3
    elsif @prev_interval == 1
      @interval = 6
    else
      @interval = (@prev_interval * @prev_ef).to_i
    end
  end

  def calculate_easiness_factor!
    @easiness_factor = @prev_ef + (0.1 - (3 - @quality_response) * ((3 - @quality_response) * 0.1))
    @easiness_factor = 1.3 if @easiness_factor < 1.3
    @easiness_factor
  end
end
