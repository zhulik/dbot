# frozen_string_literal: true

class ArticlesPractice < WordsPracticeBase
  practice_name -> { I18n.t('dbot.practice.articles') }

  private

  def word_text(word)
    word.word
  end

  def valid_answer?(word, article)
    word = current_user.words.find(word)
    [Constants::ARTICLES[word.gen] == article, word, article]
  end

  def success_answer(word, _article)
    t('common.right_article', word: with_article(word), translation: word.translation)
  end

  def fail_answer(word, article)
    t('common.wrong_article', article: article,
                              word: with_article(word),
                              translation: word.translation)
  end

  def random_word
    Words::WeighedRandom.new(current_user.current_words.noun, self.class.context).get
  end

  def keyboard(word)
    InlineKeyboard.render do |k|
      Constants::ARTICLES.values.map do |art|
        k.button art, self.class.practice_context, word.id, art
      end
      k.button InlineKeyboard::Buttons.finish(self.class.practice_context)
    end
  end
end
