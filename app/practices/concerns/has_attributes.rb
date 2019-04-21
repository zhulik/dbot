# frozen_string_literal: true

module HasAttributes
  def attributes(*names)
    self.class.class_exec do
      names.each do |name|
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
    end
  end
end
