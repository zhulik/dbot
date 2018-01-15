# frozen_string_literal: true

class DelwordCommand < Command
  usage -> { I18n.t('dbot.delword.usage') }
  help -> { I18n.t('dbot.delword.help') }
  arguments 0, 1

  def message(*args)
    return respond_message text: self.class.usage if args.count > 1
    return delword_full if args.empty?
    delword_direct(args.first)
  end

  alias send_word message

  def callback_query(query); end

  private

  def delword_full
    save_context :delword_send_word
    respond_message text: t('common.send_word')
  end

  def delword_direct(w)
    word = current_user.current_words.find_by(word: w)
    return respond_message text: t('dbot.delword.unknown_word', word: w) if word.nil?
    word.destroy
    respond_message text: t('common.word_deleted', word: word.word)
  end
end
