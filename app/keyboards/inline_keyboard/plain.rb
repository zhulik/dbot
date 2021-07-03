# frozen_string_literal: true

class InlineKeyboard::Plain
  class << self
    def render(&block)
      new(&block).render
    end
  end

  def initialize
    @columns = 3
    @default_row = InlineKeyboard::Row.new
    @rows = []
    yield self
  end

  def columns(c)
    @columns = c
  end

  def row(&block)
    @rows << InlineKeyboard::Row.new(&block)
  end

  def render
    return @rows.map(&:render) if @rows.any?

    @default_row.render.each_slice(@columns).to_a
  end

  def button(text_or_button, *callback_tokens)
    @default_row.button(text_or_button, *callback_tokens)
  end
end
