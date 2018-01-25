# frozen_string_literal: true

class ArticlesPractice < WordsPracticeBase
  practice_name -> { I18n.t('dbot.practice.articles') }

  protected

  def word_text(word)
    word.word
  end

  def valid_answer?(word, article)
    word = current_user.words.find(word)
    [Constants::ARTICLES[word.gen] == article, word, article]
  end

  def success_answer(word, _article)
    t('common.right_article', word: word.with_article, translation: word.translation)
  end

  def fail_answer(word, article)
    t('common.wrong_article', article: article,
                              word: word.with_article,
                              translation: word.translation)
  end

  def random_word
    Words::WeighedRandom.new(current_user.current_words.noun, self.class.context).get
  end

  private

  def keyboard(word)
    vars = Constants::ARTICLES.values.map do |art|
      { text: art, callback_data: "#{self.class.practice_context}:#{word.id}:#{art}" }
    end
    vars << finish_button(self.class.practice_context)
    vars.each_slice(3).to_a
  end
end
