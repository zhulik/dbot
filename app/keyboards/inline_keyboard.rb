# frozen_string_literal: true

module InlineKeyboard
  class << self
    def render(&block)
      InlineKeyboard::Plain.new(&block).render
    end
  end
end
