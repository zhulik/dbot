# frozen_string_literal: true

class WordsPracticeBase < Practice
  private

  def random_word
    Words::WeighedRandom.new(current_user.current_words, self.class.context).get
  end

  def send_stats(data)
    response = [t('common.successes')]
    data[:success].each do |s|
      response << "#{Word.find(s.first).with_article} - #{s.second}"
    end
    response << t('common.fails')
    data[:fail].each do |s|
      response << "#{Word.find(s.first).with_article} - #{s.second}"
    end
    edit_message :text, text: response.join("\n")
  end

  def update_stat!(name, *words)
    words.each do |word|
      word.inc_stat!("#{self.class.context}_#{name}")
      super(name, word.id)
    end
  end
end
