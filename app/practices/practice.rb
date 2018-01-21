# frozen_string_literal: true

class Practice < Handler
  class << self
    %i[practice_name].each do |name|
      define_method name do |*args|
        return send("_#{name}_value") if args.empty?
        instance_variable_set("@#{name}", args.first) if args.one?
        instance_variable_set("@#{name}", args) if args.many?
      end

      define_method "_#{name}_value" do
        value = instance_variable_get("@#{name}")
        return value.call if value.respond_to?(:call)
        value
      end
    end

    def context
      name.underscore.split('_')[0..-2].join('_')
    end

    def practice_context
      "practice_#{context}"
    end

    def practices
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
