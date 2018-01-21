# frozen_string_literal: true

class ArticlesPractice < Practice
  practice_name -> { I18n.t('dbot.practice.articles') }

  def start
    word = random_word(current_user.current_words.noun)
    return respond_message text: t('dbot.words.no_words_added') if word.nil?
    respond_message text: word.word, reply_markup: {
      inline_keyboard: keyboard(word)
    }
  end

  def callback_query(query)
    word, article = query.split(':')
    word = current_user.words.find(word)
    if Constants::ARTICLES[word.gen] == article
      word.articles_success!
      answer_callback_query t('common.right_article', word: with_article(word), translation: word.translation)
      return start
    end
    word.articles_fail!
    answer_callback_query t('common.wrong_article', article: article,
                                                    word: with_article(word),
                                                    translation: word.translation)
    start
  end

  private

  def keyboard(word)
    vars = Constants::ARTICLES.map do |_, art|
      { text: art, callback_data: "#{self.class.practice_context}:#{word.id}:#{art}" }
    end
    vars << finish_button(self.class.practice_context)
    vars.each_slice(3).to_a
  end
end
