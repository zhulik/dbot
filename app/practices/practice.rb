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
      descendants.select { |klass| klass.descendants.empty? }.sort_by(&:name)
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
      first, second = query.split(':')
      answer_callback_query handle_answer(first, second)
      start
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
    word = random_word
    raise NoWordsAddedError if word.nil?
    respond_message text: word_text(word), reply_markup: { inline_keyboard: keyboard(word) }
  end

  def handle_answer(prefix, type)
    valid, first, second = valid_answer?(prefix, type)
    if valid
      update_stat(:success, first)
      success_answer(first, second)
    else
      update_stat(:fail, first)
      fail_answer(first, second)
    end
  end

  def valid_answer?(_first, _second)
    raise NotImplementedError
  end

  def success_answer(_first, _second)
    raise NotImplementedError
  end

  def fail_answer(_first, _second)
    raise NotImplementedError
  end

  def word_text(_word)
    raise NotImplementedError
  end

  def finish
    data = stat.stats.each_with_object(Hash.new { [] }) do |(k, v), res|
      res[:success] = res[:success].push([k, v[:success] || 0])
      res[:fail] = res[:fail].push([k, v[:fail] || 0])
    end
    data[:success] = data[:success].sort_by(&:second).reverse[0..2]
    data[:fail] = data[:fail].sort_by(&:second).reverse[0..2]
    send_stats(data)
  end

  def finish_button(ctx)
    { text: t('common.finish'), callback_data: "#{ctx}:finish" }
  end

  def update_stat(name, *entities)
    entities.each do |entity|
      stat.stats[entity.to_s] = stat.stats[entity.to_s].merge(name => (stat.stats[entity.to_s][name] || 0) + 1)
    end
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
