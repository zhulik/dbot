# frozen_string_literal: true

class InlineKeyboard::Button
  def initialize(text, *tokens)
    @text = text
    @tokens = tokens
  end

  def render
    { text: @text, callback_data: @tokens.join(':') }
  end
end
