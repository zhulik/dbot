# frozen_string_literal: true

class StatsHashSerializer
  class << self
    def dump(serializer)
      serializer.data
    end

    def load(hash)
      new(hash)
    end
  end

  attr_reader :data

  def initialize(hash)
    klass = ActiveSupport::HashWithIndifferentAccess
    @data = klass.new { klass.new(0) }.tap do |res|
      (hash || {}).each do |k, v|
        res[k] = v
      end
    end
  end

  # rubocop:disable Style/MultilineBlockChain
  def printable
    @data.each_with_object(Hash.new { [] }) do |(k, v), res|
      res[:success] = res[:success].push([k, v[:success] || 0])
      res[:fail] = res[:fail].push([k, v[:fail] || 0])
    end.tap do |data|
      data[:success] = data[:success].sort_by(&:second).reverse[0..2]
      data[:fail] = data[:fail].sort_by(&:second).reverse[0..2]
    end
  end
  # rubocop:enable Style/MultilineBlockChain

  def update_stat!(name, entity)
    @data[entity.to_s] = @data[entity.to_s].merge(name => (@data[entity.to_s][name] || 0) + 1)
  end
end
