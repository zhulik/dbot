# frozen_string_literal: true

class TranslateCommandBase < Command
  def message(*args)
    return full if args.empty?
    short(args.join(' '))
  end

  alias send_sentence message

  def callback_query(*)
    message = session.delete(:message_to_handle)
    reply_markup, text = prepare_workflow(message)
    respond_message text: text, reply_markup: reply_markup
  end

  private

  def full
    save_context context_name
    respond_message text: t('common.send_sentence')
  end

  def short(sentence)
    reply_markup, text = prepare_workflow(sentence)
    respond_message text: text, reply_markup: reply_markup
  end

  def prepare_workflow(sentence)
    text = translate(sentence)
    clean = text.tr('.', ' ').strip
    reply_markup = nil
    if clean.split.one? && !current_user.word?(clean)
      reply_markup = { inline_keyboard: addword_keyboard(clean, :addword) }
    end
    [reply_markup, text]
  end
end
