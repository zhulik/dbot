# frozen_string_literal: true

class HelpCommand < Command
  usage -> { I18n.t('dbot.help.usage') }
  help -> { I18n.t('dbot.help.help') }

  arguments 0

  def message_0
    Rails.application.eager_load! if Rails.env.development?
    msg = Command.all.map do |cmd|
      "#{cmd.command} - #{cmd.help}"
    end.join("\n")
    respond_message text: msg
  end
end
