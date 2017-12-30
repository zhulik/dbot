# frozen_string_literal: true

describe TelegramWebhooksController, :telegram_bot do
  describe '#start' do
    subject { dispatch_message '/start' }

    context 'with new user' do
      it 'responds with valid message' do
        expect { subject }.to respond_with_message 'Hi, my friend!'
      end

      include_examples 'creates new', User
    end

    context 'with existing' do
      context 'active user' do
        let!(:user) { create :user, user_id: 123 }

        include_examples 'does not create new', User
      end

      context 'inactive user' do
        let!(:user) { create :user, :inactive, user_id: 123 }

        include_examples 'does not create new', User
      end
    end
  end
end
