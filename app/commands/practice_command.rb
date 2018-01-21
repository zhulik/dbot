# frozen_string_literal: true

class PracticeCommand < Command
  usage -> { I18n.t('dbot.practice.usage') }
  help -> { I18n.t('dbot.practice.help') }
  arguments 0

  def message_0
    respond_message text: t('dbot.practice.what_practice'), reply_markup: { inline_keyboard: practices_keyboard }
  end

  def callback_query(type)
    practice(type).start
  end

  def context_callback_query(ctx, query)
    practice(ctx).handle_callback_query(query)
  end

  private

  def practices_keyboard
    Rails.application.eager_load! if Rails.env.development?
    Practice.practices.map do |klass|
      { text: klass.practice_name, callback_data: "practice:#{klass.context}" }
    end.each_slice(2).to_a
  end

  def practice(type)
    "#{type}_practice".camelize.constantize.new(bot, session, payload)
  end
end
