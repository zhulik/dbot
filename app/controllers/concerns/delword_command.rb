# frozen_string_literal: true

module DelwordCommand
  def delword(*args)
    return respond_with :message, text: t('.usage') if args.count != 1
    word = current_user.current_words.find_by(word: args.first)
    return respond_with :message, text: t('.unknown_word', word: args.first) if word.nil?
    word.destroy
    respond_with :message, text: t('.word_deleted', word: args.first)
  end
end
