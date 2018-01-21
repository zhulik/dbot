# frozen_string_literal: true

class Practice < Handler
  class << self
    %i[practice_name].each do |name|
      define_method name do |*args|
        return send("_#{name}_value") if args.empty?
        instance_variable_set("@#{name}", args.first) if args.one?
        instance_variable_set("@#{name}", args) if args.many?
      end

      define_method "_#{name}_value" do
        value = instance_variable_get("@#{name}")
        return value.call if value.respond_to?(:call)
        value
      end
    end

    def context
      name.underscore.split('_')[0..-2].join('_')
    end

    def practice_context
      "practice_#{context}"
    end

    def practices
      descendants.select { |klass| klass.descendants.empty? }
    end
  end
end
