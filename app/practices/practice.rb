# frozen_string_literal: true

class Practice < Handler
  extend HasAttributes
  attributes :practice_name

  class << self
    def context
      name.underscore.split('_')[0..-2].join('_')
    end

    def practice_context
      "practice_#{context}"
    end

    def all
      descendants.select { |klass| klass.descendants.empty? }
    end
  end

  def start
    # do nothing, abstract
  end

  def handle_callback_query(query)
    return respond_message text: t('common.finished') if query == 'finish'
    callback_query(query)
  end

  protected

  def random_word(scope = nil)
    scope ||= current_user.current_words
    Words::WeighedRandom.new(scope, self.class.context).get
  end

  def finish_button(ctx)
    { text: t('common.finish'), callback_data: "#{ctx}:finish" }
  end

  def with_article(word)
    return word.word unless word.noun?
    "#{Constants::ARTICLES[word.gen] || 'unk'} #{word.word.capitalize}"
  end
end
