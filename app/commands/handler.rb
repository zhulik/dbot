# frozen_string_literal: true

class Handler
  include Telegram::Bot::UpdatesController::ReplyHelpers
  include ApplicationHelper
  include ActionView::Helpers::TranslationHelper

  attr_reader :bot, :session, :payload

  def initialize(bot, session, payload)
    @bot = bot
    @session = session
    @payload = payload
  end

  def message(*args)
    # do nothing, abstract
  end

  def callback_query(query)
    # do nothing, abstract
  end

  def context_callback_query(ctx, query)
    # do nothing, abstract
  end
end
