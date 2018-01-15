# frozen_string_literal: true

class PracticeCommand < Command
  usage -> { I18n.t('dbot.practice.usage') }
  help -> { I18n.t('dbot.practice.help') }
  arguments 0

  ARTICLES = {
    'f' => 'die',
    'm' => 'der',
    'n' => 'das',
    nil: 'unk'
  }.freeze

  def message_0
    respond_message text: t('dbot.practice.what_practice'), reply_markup: { inline_keyboard: practices_keyboard }
  end

  def callback_query(type)
    send("start_practice_#{type}")
  end

  def wordsfrom_callback_query(query)
    return respond_message text: t('common.finished') if query == 'finish'
    handle_practice_callback_query(query, :wordsfrom)
  end

  def wordsto_callback_query(query)
    return respond_message text: t('common.finished') if query == 'finish'
    handle_practice_callback_query(query, :wordsto)
  end

  private

  def practices_keyboard
    [].tap do |keys|
      keys << { text: t('dbot.practice.wordsfrom'), callback_data: 'practice:wordsfrom' }
      keys << { text: t('dbot.practice.wordsto'), callback_data: 'practice:wordsto' }
    end.each_slice(2).to_a
  end

  def start_practice_wordsfrom
    word = Words::WeighedRandom.new(current_user.current_words, :wordsfrom).get
    return respond_message text: t('dbot.words.no_words_added') if word.nil?
    variants = Words::Variants.new(current_user, word).get
    respond_message text: with_article(word), reply_markup: {
      inline_keyboard: wordsfrom_keyboard(word, variants)
    }
  end

  def start_practice_wordsto
    word = Words::WeighedRandom.new(current_user.current_words, :wordsto).get
    return respond_message text: t('dbot.words.no_words_added') if word.nil?
    variants = Words::Variants.new(current_user, word).get
    respond_message text: word.translation, reply_markup: {
      inline_keyboard: wordsto_keyboard(word, variants)
    }
  end

  def handle_practice_callback_query(query, type)
    w1, w2 = query.split(':')
    w1 = current_user.words.find(w1)
    w2 = current_user.words.find(w2)
    if w1 == w2 # right answer
      w1.send("#{type}_success!")
      answer_callback_query t('common.right', word: w1.word, translation: w1.translation)
      return send("start_practice_#{type}")
    end
    w1.send("#{type}_fail!")
    w2.send("#{type}_fail!")
    answer_callback_query t('common.wrong', right_word: w1.word, right_translation: w1.translation,
                                            wrong_word: w2.word, wrong_translation: w2.translation)
    send("start_practice_#{type}")
  end

  def wordsfrom_keyboard(word, variants)
    vars = variants.map do |w|
      { text: w.translation, callback_data: "practice_wordsfrom:#{word.id}:#{w.id}" }
    end
    vars << finish_button(:practice_wordsfrom)
    vars.each_slice(2).to_a
  end

  def finish_button(ctx)
    { text: t('common.finish'), callback_data: "#{ctx}:finish" }
  end

  def wordsto_keyboard(word, variants)
    vars = variants.map do |w|
      { text: with_article(w), callback_data: "practice_wordsto:#{word.id}:#{w.id}" }
    end
    vars << finish_button(:practice_wordsto)
    vars.each_slice(2).to_a
  end

  def with_article(word)
    return word.word unless word.noun?
    "#{ARTICLES[word.gen]} #{word.word.capitalize}"
  end
end
