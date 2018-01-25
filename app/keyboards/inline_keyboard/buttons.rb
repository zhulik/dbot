# frozen_string_literal: true

class InlineKeyboard::Buttons
  class << self
    def cancel(ctx)
      InlineKeyboard::Button.new(I18n.t('common.cancel'), ctx, :cancel)
    end

    def finish(ctx)
      InlineKeyboard::Button.new(I18n.t('common.finish'), ctx, :finish)
    end
  end
end
