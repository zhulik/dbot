# frozen_string_literal: true

class TranslatetoCommand < Command
  include ButtonsHelper

  help -> { I18n.t('dbot.translateto.help') }
  arguments :any

  def message(*args)
    return translateto_full if args.empty?
    translateto_direct(args.join(' '))
  end

  alias send_sentence message

  def callback_query(_query)
    message = session.delete(:message_to_handle)
    reply_markup, text = prepare_translateto_workflow(message)
    respond_message text: text, reply_markup: reply_markup
  end

  private

  def translateto_full
    save_context :translateto_send_sentence
    respond_message text: t('common.send_sentence')
  end

  def translateto_direct(sentence)
    reply_markup, text = prepare_translateto_workflow(sentence)
    respond_message text: text, reply_markup: reply_markup
  end

  def prepare_translateto_workflow(sentence)
    text = Translators::YandexWrapper.new(sentence).translate('ru', current_language)
    clean = text.tr('.', ' ').strip
    reply_markup = nil
    if clean.split.one? && !current_user.word?(clean)
      reply_markup = { inline_keyboard: addword_keyboard(clean, :addword) }
    end
    [reply_markup, text]
  end
end
