# frozen_string_literal: true

module DelwordCommand
  extend ActiveSupport::Concern

  included do
    context_handler :delword_send_word do |*ws|
      delword_direct(ws.first)
    end
  end

  def delword(*args)
    return respond_with :message, text: t('.usage') if args.count > 1
    return delword_full if args.empty?
    delword_direct(args.first)
  end

  private

  def delword_full
    save_context :delword_send_word
    respond_with :message, text: t('common.send_word')
  end

  def delword_direct(w)
    word = current_user.current_words.find_by(word: w)
    return respond_with :message, text: t('.unknown_word', word: w) if word.nil?
    word.destroy
    respond_with :message, text: t('common.word_deleted', word: word.word)
  end
end
