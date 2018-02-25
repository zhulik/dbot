# frozen_string_literal: true

class DelwordCommand < Command
  usage -> { I18n.t('dbot.delword.usage') }
  help -> { I18n.t('dbot.delword.help') }
  arguments 0, 1

  def message_0
    save_context :delword_send_word
    respond_message text: t('common.send_word_id')
  end

  def message_1(id)
    short(id)
  end
  alias send_word message_1

  private

  def short(id)
    word = current_user.current_words.find_by(id: id)
    return respond_message text: t('dbot.delword.unknown_word', word_id: id) if word.nil?
    word.destroy
    respond_message text: t('common.word_deleted', word: word.word)
  end
end
