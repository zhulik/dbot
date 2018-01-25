# frozen_string_literal: true

class PrefixesPractice < Practice
  practice_name -> { I18n.t('dbot.practice.prefixes') }

  private

  def word_text(word)
    word
  end

  def valid_answer?(prefix, type)
    [Constants::PREFIXES[type].include?(prefix), prefix, type]
  end

  def success_answer(prefix, type)
    t('common.right_prefix', prefix: prefix, right_type: type)
  end

  def fail_answer(prefix, type)
    t('common.wrong_prefix', type: type, prefix: prefix, right_type: right_type(prefix))
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

  def random_word
    Constants::PREFIXES.values.flatten.sample
  end

  def right_type(prefix)
    right_type = nil
    Constants::PREFIXES.each do |t, prefixes|
      right_type = t if prefixes.include?(prefix)
    end
    right_type
  end

  def keyboard(prefix)
    InlineKeyboard.render do |k|
      Constants::PREFIXES.keys.map do |type|
        k.button type, self.class.practice_context, prefix, type
      end
      k.button InlineKeyboard::Buttons.finish(self.class.practice_context)
    end
  end
end
