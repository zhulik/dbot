# frozen_string_literal: true

describe TelegramWebhooksController, :telegram_bot do
  describe '#start' do
    subject { -> { dispatch_message '/start' } }
    it { should respond_with_message 'Hi, my friend!' }
  end
end
