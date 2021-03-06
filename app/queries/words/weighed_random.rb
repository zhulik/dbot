# frozen_string_literal: true

class Words::WeighedRandom
  def initialize(scope, practice)
    @scope = scope
    @practice = practice
  end

  def get
    return nil if @scope.empty?

    weights = @scope.map { |w| [w, w.practice_stats["#{@practice}_success"] - w.practice_stats["#{@practice}_fail"]] }
                    .sort_by(&:second)
    max = weights.max_by(&:second).second
    weights = weights[0..50].to_h
    Pickup.new(weights) { |v| max * 3 + 1 - v }.pick
  end
end
