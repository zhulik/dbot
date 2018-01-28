# frozen_string_literal: true

class Practice < Handler
  extend HasAttributes
  extend HasDescendants

  attributes :practice_name

  attr_accessor :stat

  class << self
    def context
      name.underscore.split('_')[0..-2].join('_')
    end

    def practice_context
      "practice_#{context}"
    end
  end

  def handle_start
    with_practice_stat do
      start
    end
  end

  def handle_finish
    with_practice_stat do
      stat.finished!
      finish
    end
  end

  private

  def start
    raise NotImplementedError
  end

  def word_text(_word)
    raise NotImplementedError
  end

  def finish
    send_stats(stat.stats.printable)
  end

  def update_stat!(name, *entities)
    entities.each do |entity|
      stat.stats.update_stat!(name, entity)
    end
  end

  def with_practice_stat
    existing = PracticeStat.find_by(chat_id: payload.message.chat.id, status: 'in_progress')
    @stat = if existing.nil?
              new_stat
            elsif existing.practice == self.class.context
              existing
            else
              Practices::Finish.call(bot, existing)
              new_stat
            end
    yield
    stat.save!
  end

  def new_stat
    current_user.practice_stats.create!(practice: self.class.context,
                                        message_id: payload.message.message_id,
                                        chat_id: payload.message.chat.id)
  end
end
