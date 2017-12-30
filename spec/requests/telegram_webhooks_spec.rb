# frozen_string_literal: true

describe TelegramWebhooksController, :telegram_bot do
  describe '#start' do
    subject { dispatch_message '/start' }

    context 'with new user' do
      include_examples 'responds with message', 'Hi, my friend!'

      include_examples 'creates new', User
    end

    context 'with existing' do
      context 'active user' do
        let!(:user) { create :user, user_id: 123 }

        include_examples 'responds with message', 'We have already started!'

        include_examples 'does not create new', User
      end

      context 'inactive user' do
        let!(:user) { create :user, :inactive, user_id: 123 }
        include_examples 'responds with message', 'Your subscription has been reactivated!'

        include_examples 'does not create new', User
      end
    end
  end
end
