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
    @practice_stat.finished!
    @bot.edit_message_text(message_id: @practice_stat.message_id,
                           text: I18n.t('common.finished'),
                           chat_id: @practice_stat.chat_id)
  end
end
