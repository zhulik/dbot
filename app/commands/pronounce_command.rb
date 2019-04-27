# frozen_string_literal: true

class PronounceCommand < Command
  help -> { I18n.t('dbot.pronounce.help') }
  arguments :any

  def message(*args)
    return full if args.empty?

    short(args.join(' '))
  end

  alias send_sentence message

  private

  def full
    save_context :pronounce_send_sentence
    respond_message text: t('common.send_sentence')
  end

  def short(phrase)
    TTS::CachedTTS.new(phrase, current_user.language).get do |payload|
      respond_with :voice, voice: payload
      nil
    end
  end
end
