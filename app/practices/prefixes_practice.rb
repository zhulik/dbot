# frozen_string_literal: true

class PrefixesPractice < Practice
  practice_name -> { I18n.t('dbot.practice.prefixes') }

  protected

  def start
    respond_message text: prefix, reply_markup: {
      inline_keyboard: keyboard(prefix)
    }
  end

  def callback_query(query)
    prefix, type = query.split(':')
    answer = if Constants::PREFIXES[type].include?(prefix)
               update_stat(prefix, :success)
               t('common.right_prefix', prefix: prefix, right_type: type)
             else
               update_stat(prefix, :fail)
               t('common.wrong_prefix', type: type, prefix: prefix, right_type: right_type(prefix))
             end
    answer_callback_query answer
    start
  end

  def send_stats(data)
    response = [t('common.successes')]
    data[:success].each do |s|
      response << "#{s.first} - #{s.second}"
    end
    response << t('common.fails')
    data[:fail].each do |s|
      response << "#{s.first} - #{s.second}"
    end
    edit_message :text, text: response.join("\n")
  end

  private

  def right_type(prefix)
    right_type = nil
    Constants::PREFIXES.each do |t, prefixes|
      right_type = t if prefixes.include?(prefix)
    end
    right_type
  end

  def keyboard(prefix)
    vars = Constants::PREFIXES.map do |type, _|
      { text: type, callback_data: "#{self.class.practice_context}:#{prefix}:#{type}" }
    end
    vars << finish_button(self.class.practice_context)
    vars.each_slice(3).to_a
  end

  def prefix
    @prefix ||= Constants::PREFIXES.values.flatten.sample
  end
end
