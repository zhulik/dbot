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

        it 'updates user to active' do
          subject
          expect(user.reload).to be_active
        end

        include_examples 'does not create new', User
      end
    end
  end

  describe '#languages' do
    subject { dispatch_message '/languages' }

    context 'with existing user' do
      let!(:user) { create :user, user_id: 123 }

      context 'with no languages in the DB' do
        include_examples 'responds with message', 'Sorry, languages are not created yet!'
      end

      context 'with existing languages' do
        let!(:lang1) { create :language, name: 'Deutsch', slug: 'DEU' }
        let!(:lang2) { create :language, name: 'English', slug: 'ENG' }

        it 'responds with valid message' do
          expect { subject }.to send_telegram_message(bot,
                                                      'Choose the language you will work with:',
                                                      reply_markup: {
                                                        inline_keyboard: [[
                                                          { text: 'Deutsch', callback_data: 'DEU' },
                                                          { text: 'English', callback_data: 'ENG' }
                                                        ]]
                                                      })
        end
      end
    end

    context 'with non-existing user' do
      include_examples 'responds with message', 'Sorry, you are not authorized, use /start'
    end
  end
end
