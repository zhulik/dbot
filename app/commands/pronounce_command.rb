# frozen_string_literal: true

class PronounceCommand < Command
  help -> { I18n.t('dbot.pronounce.help') }
  arguments :any

  def message(*args)
    return pronounce_full if args.empty?
    pronounce_direct(args.join(' '))
  end

  alias send_sentence message

  private

  def pronounce_full
    save_context :pronounce_send_sentence
    respond_message text: t('common.send_sentence')
  end

  def pronounce_direct(phrase)
    TTS::CachedTTS.new(phrase, current_user.language).get do |payload|
      respond_with :voice, voice: payload
    end
  end
end
