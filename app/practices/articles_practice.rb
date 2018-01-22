# frozen_string_literal: true

class ArticlesPractice < Practice
  practice_name -> { I18n.t('dbot.practice.articles') }

  protected

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
    answer = if Constants::ARTICLES[word.gen] == article
               word.inc_stat!('articles_success')
               t('common.right_article', word: with_article(word), translation: word.translation)
             else
               word.inc_stat!('articles_fail')
               t('common.wrong_article', article: article,
                                         word: with_article(word),
                                         translation: word.translation)
             end
    answer_callback_query answer
    start
  end

  def finish
    edit_message :text, text: t('common.finished')
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
