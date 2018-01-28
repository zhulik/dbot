# frozen_string_literal: true

module HasDescendants
  def all
    descendants.select { |klass| klass.descendants.empty? }.sort_by(&:name)
  end
end
