# frozen_string_literal: true

class PracticeCommand < Command
  usage -> { I18n.t('dbot.practice.usage') }
  help -> { I18n.t('dbot.practice.help') }
  arguments 0

  def message_0
    respond_message text: t('dbot.practice.what_practice'), reply_markup: { inline_keyboard: practices_keyboard }
  end

  def callback_query(type)
    practice(type).handle_start
  end

  def context_callback_query(ctx, query)
    practice(ctx).handle_callback_query(query)
  end

  private

  def practices_keyboard
    Rails.application.eager_load! if Rails.env.development?
    InlineKeyboard.render do |k|
      k.columns 2
      Practice.all.map do |klass|
        k.button klass.practice_name, "practice:#{klass.context}"
      end
    end
  end

  def practice(type)
    Practice.all.find { |p| p.context == type }.new(bot, session, payload)
  end
end
