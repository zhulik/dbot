# frozen_string_literal: true

class TranslatefromCommand < Command
  include ButtonsHelper

  help -> { I18n.t('dbot.translatefrom.help') }
  arguments :any

  def message(*args)
    return translatefrom_full if args.empty?
    translatefrom_direct(args.join(' '))
  end

  alias send_sentence message

  def callback_query(_query)
    message = session.delete(:message_to_handle)
    reply_markup, text = prepare_translatefrom_workflow(message)
    respond_message text: text, reply_markup: reply_markup
  end

  private

  def translatefrom_full
    save_context :translatefrom_send_sentence
    respond_message text: t('common.send_sentence')
  end

  def translatefrom_direct(sentence)
    reply_markup, text = prepare_translatefrom_workflow(sentence)
    respond_message text: text, reply_markup: reply_markup
  end

  def prepare_translatefrom_workflow(sentence)
    text = Translators::YandexWrapper.new(sentence).translate(current_language, 'ru')
    clean = text.tr('.', ' ').strip
    reply_markup = nil
    if clean.split.one? && !current_user.word?(clean)
      reply_markup = { inline_keyboard: addword_keyboard(clean, 'addword') }
    end
    [reply_markup, text]
  end
end
