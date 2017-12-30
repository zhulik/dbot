# frozen_string_literal: true

require 'telegram/bot/rspec/integration'

RSpec.configuration.after { Telegram.bot.reset }
