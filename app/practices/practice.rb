# frozen_string_literal: true

class Practice < Handler
  extend HasAttributes
  attributes :practice_name

  attr_accessor :stat

  class << self
    def context
      name.underscore.split('_')[0..-2].join('_')
    end

    def practice_context
      "practice_#{context}"
    end

    def all
      descendants.select { |klass| klass.descendants.empty? }
    end
  end

  def handle_start
    with_practice_stat do
      start
    end
  end

  def handle_callback_query(query)
    with_practice_stat do
      return Practices::Finish.call(bot, stat) if query == 'finish' # print stats
      callback_query(query)
    end
  end

  def handle_finish
    with_practice_stat do
      stat.finished!
      finish
    end
  end

  protected

  def start
    # do nothing, abstract
  end

  def callback_query(query)
    # do nothing, abstract
  end

  def finish
    # do nothing, abstract
  end

  def random_word(scope = nil)
    scope ||= current_user.current_words
    Words::WeighedRandom.new(scope, self.class.context).get
  end

  def finish_button(ctx)
    { text: t('common.finish'), callback_data: "#{ctx}:finish" }
  end

  def with_article(word)
    return word.word unless word.noun?
    "#{Constants::ARTICLES[word.gen] || 'unk'} #{word.word.capitalize}"
  end

  private

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
