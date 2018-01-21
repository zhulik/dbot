# frozen_string_literal: true

class DefaultHashSerializer
  class << self
    def dump(hash)
      hash
    end

    def load(hash)
      Hash.new { 0 }.tap do |res|
        (hash || {}).each do |k, v|
          res[k] = v
        end
      end.with_indifferent_access
    end
  end
end
