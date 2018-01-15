# frozen_string_literal: true

class Command
  include Telegram::Bot::UpdatesController::ReplyHelpers
  include UsersHelper
  include ApplicationHelper
  include ActionView::Helpers::TranslationHelper

  class << self
    %i[help usage arguments].each do |name|
      define_method name do |*args|
        return send("_#{name}_value") if args.empty?
        instance_variable_set("@#{name}", args.first) if args.one?
        instance_variable_set("@#{name}", args) if args.many?
      end

      define_method "_#{name}_value" do
        value = instance_variable_get("@#{name}")
        return value.call if value.respond_to?(:call)
        value
      end
    end
  end

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
end
