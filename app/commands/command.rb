# frozen_string_literal: true

class Command < Handler
  extend HasAttributes
  attributes :help, :usage, :arguments

  def validate_and_handle_message(*args)
    arity = self.class.arguments
    return respond_message text: self.class.usage if arity != :any && ![arity].flatten.include?(args.count)
    return message(*args) if arity == :any
    send("message_#{args.count}", *args)
  end

  private

  def save_context(ctx)
    session[:context] = ctx
  end
end
