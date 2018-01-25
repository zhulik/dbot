# frozen_string_literal: true

class InlineKeyboard::Row
  def initialize
    @buttons = []
    yield self if block_given?
  end

  def button(text_or_button, *callback_tokens)
    if callback_tokens.present? && text_or_button.is_a?(String)
      @buttons << InlineKeyboard::Button.new(text_or_button, callback_tokens)
    elsif text_or_button.is_a?(InlineKeyboard::Button)
      @buttons << text_or_button
    else
      raise ArgumentError
    end
  end

  def render
    @buttons.map(&:render)
  end
end
