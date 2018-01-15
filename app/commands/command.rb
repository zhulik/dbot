# frozen_string_literal: true

class Command < Handler
  class << self
    %i[help usage arguments].each do |name|
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

  def validate_and_handle_message(*args)
    arity = self.class.arguments
    return respond_message text: self.class.usage if arity != :any && ![arity].flatten.include?(args.count)
    return message(*args) if arity == :any
    send("message_#{args.count}", *args)
  end

  protected

  def save_context(ctx)
    session[:context] = ctx
  end
end
