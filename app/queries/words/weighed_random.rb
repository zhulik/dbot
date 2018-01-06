# frozen_string_literal: true

class Words::WeighedRandom
  def initialize(scope, practice)
    @scope = scope
    @practice = practice
  end

  def get
    return nil if @scope.empty?
    weights = @scope.map { |w| [w, w.send("#{@practice}_success") - w.send("#{@practice}_fail")] }
    max = weights.max_by(&:second).second
    weights = weights.to_h
    Pickup.new(weights) { |v| max * 3 + 1 - v }.pick
  end
end
