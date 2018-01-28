# frozen_string_literal: true

class InlinePractice < Practice
  def handle_callback_query(query)
    with_practice_stat do
      return Practices::Finish.call(bot, stat) if query == 'finish' # print stats
      first, second = query.split(':')
      answer_callback_query handle_answer(first, second)
      start
    end
  end

  private

  def handle_answer(prefix, type)
    valid, first, second = valid_answer?(prefix, type)
    if valid
      update_stat!(:success, first)
      success_answer(first, second)
    else
      update_stat!(:fail, first)
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
    send_stats(stat.stats.printable)
  end
end
