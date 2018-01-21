# frozen_string_literal: true

class PrefixesPractice < Practice
  practice_name -> { I18n.t('dbot.practice.prefixes') }

  def start
    prefix = Constants::PREFIXES.values.flatten.sample
    respond_message text: prefix, reply_markup: {
      inline_keyboard: keyboard(prefix)
    }
  end

  def callback_query(query)
    prefix, type = query.split(':')
    if Constants::PREFIXES[type].include?(prefix)
      answer_callback_query t('common.right_article', word: prefix)
      return start
    end
    right_type = nil
    Constants::PREFIXES.each do |t, prefixes|
      right_type = t if prefixes.include?(prefix)
    end
    answer_callback_query t('common.wrong_article', article: type, word: "#{prefix} - #{right_type}")
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
end
