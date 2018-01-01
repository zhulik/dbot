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
        let!(:lang1) { create :language, name: 'Deutsch', slug: 'de' }
        let!(:lang2) { create :language, name: 'English', slug: 'en' }
        let!(:session) { { test: 1 } }
        before do
          override_session(session)
        end

        it 'responds with valid message' do
          expect { subject }.to send_telegram_message(bot,
                                                      'Choose the language you will work with:',
                                                      reply_markup: {
                                                        inline_keyboard: [[
                                                          { text: 'Deutsch', callback_data: 'de' },
                                                          { text: 'English', callback_data: 'en' }
                                                        ]]
                                                      })
        end

        it 'updates context' do
          subject
          expect(session[:context]).to eq(:languages)
        end
      end
    end

    context 'with non-existing user' do
      include_examples 'responds with message', 'Sorry, you are not authorized, use /start'
    end
  end

  describe '#callback_query', :callback_query do
    subject { dispatch callback_query: payload }
    let(:payload) { { id: '11', from: from, message: message, data: data } }
    let(:message) { { message_id: 22, chat: chat, text: 'message text' } }
    let(:data) { 'de' }
    before { override_session(context: :languages) }

    context 'with existing user' do
      let!(:user) { create :user, user_id: 123 }

      context 'with valid language payload' do
        let!(:lang) { create :language, name: 'Deutsch', slug: 'de' }

        it 'answers with valid response and updates user\' lang' do
          expect { subject }.to answer_callback_query('Language changed: Deutsch')
          expect(user.reload.language).to eq(lang)
        end
      end

      context 'with invalid payload' do
        it 'answers with error response' do
          expect { subject }.to answer_callback_query('Unknown language: de')
        end
      end
    end

    context 'with non-existing user' do
      it 'answers with valid response' do
        expect { subject }.to answer_callback_query('Sorry, you are not authorized, use /start')
      end
    end
  end
end
