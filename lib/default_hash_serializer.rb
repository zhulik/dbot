# frozen_string_literal: true

class DefaultHashSerializer
  def initialize(&block)
    @default = block
  end

  def dump(hash)
    hash
  end

  def load(hash)
    Hash.new(&@default).tap do |res|
      (hash || {}).each do |k, v|
        res[k] = v
      end
    end.with_indifferent_access
  end
end
