# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include ControllerConfig
  include StartCommand
  include LanguagesCommand
  include WordsCommand
  include DelwordCommand
  include AddwordCommand

  def callback_query(query)
    context = session.delete(:context)
    return answer_callback_query t('.unknown_action') if context.nil?
    send("handle_callback_query_action_#{context}", query)
  end
end
