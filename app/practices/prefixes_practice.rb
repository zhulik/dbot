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
    if Constants::PREFIXES[type].include?(prefix)
      answer_callback_query t('common.right_prefix', prefix: prefix, right_type: type)
      return start
    end
    right_type = nil
    Constants::PREFIXES.each do |t, prefixes|
      right_type = t if prefixes.include?(prefix)
    end
    answer_callback_query t('common.wrong_prefix', type: type, prefix: prefix, right_type: right_type)
    start
  end

  private

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
