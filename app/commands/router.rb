# frozen_string_literal: true

class Router
  include Telegram::Bot::UpdatesController::ReplyHelpers
  include ApplicationHelper
  include ActionView::Helpers::TranslationHelper

  attr_reader :bot, :session, :payload, :action_name, :context

  def initialize(bot, session, payload, action_name, context)
    @bot = bot
    @session = session
    @payload = payload
    @action_name = action_name.last == '!' ? action_name[0..-2] : action_name
    @context = context
  end

  def handle!
    case payload
    when Telegram::Bot::Types::CallbackQuery
      handle_callback_query!
    when Telegram::Bot::Types::Message
      handle_message!
    end
  end

  def handle_callback_query!
    tokens = payload.data.split(':')
    c_tokens = tokens.first.split('_')
    sub_ctx = c_tokens[1..]
    sub_ctx = sub_ctx.any? ? "#{sub_ctx.join('_')}_" : ''
    return message_handler.public_send("#{sub_ctx}callback_query", tokens[1..].join(':')) if c_tokens[0] == 'message'

    m = "#{sub_ctx}callback_query"
    cmd = command_for(c_tokens.first)
    return cmd.public_send(m, tokens[1..].join(':')) if cmd.respond_to?(m)

    cmd.context_callback_query(c_tokens.second, tokens[1..].join(':'))
  end

  def handle_message!
    if context.present?
      ctx_tokens = context.to_s.split('_')
      return command_for(ctx_tokens.first).public_send(ctx_tokens[1..].join('_'), *payload.text&.split)
    end
    return message_handler.message(*payload.text.split) if action_name == 'message'

    command_for(action_name).validate_and_handle_message(*payload.text.split[1..])
  end

  def command_for(name)
    "#{name}_command".camelize.constantize.new(bot, session, payload)
  rescue NameError
    raise UnknownCommandError
  end

  def message_handler
    MessageHandler.new(bot, session, payload)
  end
end
