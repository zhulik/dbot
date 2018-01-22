# frozen_string_literal: true

class Practices::Finish
  class << self
    def call(bot, practice_stat)
      new(bot, practice_stat).call
    end
  end

  def initialize(bot, practice_stat)
    @bot = bot
    @practice_stat = practice_stat
  end

  def call
    practice.handle_finish
  end

  private

  def practice
    "#{@practice_stat.practice}_practice".camelize.constantize.new(@bot, {}, payload) # session is not available here
  end

  def payload
    Telegram::Bot::Types::CallbackQuery.new(message:
                                              Telegram::Bot::Types::Message.new(
                                                message_id: @practice_stat.message_id,
                                                chat: Telegram::Bot::Types::Chat.new(id: @practice_stat.chat_id)
                                              ))
  end
end
