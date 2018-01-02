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
        let!(:session) { {} }
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

        it 'changes context' do
          subject
          expect(session[:context]).to eq(:languages)
        end
      end
    end

    context 'with non-existing user' do
      include_examples 'responds with message', 'Sorry, you are not authorized, use /start'
    end
  end

  describe '#addword' do
    let!(:session) { {} }
    before do
      override_session(session)
    end

    context 'with existing user' do
      let!(:language) { create :language, name: 'Deutsch', slug: 'de' }
      let!(:user) { create :user, user_id: 123, language: language }

      context 'without arguments' do
        subject { dispatch_message '/addword' }
        include_examples 'responds with message', 'Wrong arguments count. Usage: /addword <word> [translation]'
      end

      context 'with one argument' do
        subject { dispatch_message '/addword eine' }
        around do |example|
          VCR.use_cassette('translator') do
            example.run
          end
        end

        context 'with new word' do
          it 'responds with valid message' do
            expect { subject }.to send_telegram_message(bot,
                                                        'Is it right translation: один?',
                                                        reply_markup: {
                                                          inline_keyboard: [[
                                                            { text: '👍 Yes', callback_data: 'yes' },
                                                            { text: '👎 No', callback_data: 'no' },
                                                            { text: '❌ Cancel', callback_data: 'cancel' }
                                                          ]]
                                                        })
          end

          it 'changes session' do
            subject
            expect(session[:context]).to eq(:word_confirmation)
            expect(session[:word]).to eq('eine')
            expect(session[:translation]).to eq('один')
          end
        end

        context 'with known word' do
          let!(:word) { create :word, word: 'eine', translation: 'one', user: user, language: language }

          include_examples 'responds with message', 'Word eine is already added!'
        end
      end

      context 'with two arguments' do
        subject { dispatch_message '/addword eine one' }

        include_examples 'creates new', Word
        include_examples 'responds with message', 'Word has been successfully added: eine - one'

        it 'creates valid word' do
          subject
          word = Word.last
          expect(word.word).to eq('eine')
          expect(word.translation).to eq('one')
        end
      end

      context 'with many arguments' do
        subject { dispatch_message '/addword test test test' }
        include_examples 'responds with message', 'Wrong arguments count. Usage: /addword <word> [translation]'
      end
    end

    context 'with non-existing user' do
      subject { dispatch_message '/addword eine' }

      include_examples 'responds with message', 'Sorry, you are not authorized, use /start'
    end
  end

  describe '#words' do
    let!(:language) { create :language, name: 'Deutsch', slug: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }
    subject { dispatch_message '/words' }

    context 'with existing words' do
      let!(:word) { create :word, language: language, user: user, word: 'word', translation: 'translation' }

      include_examples 'responds with message', "Your saved words:\nword - translation"
    end

    context 'with no languages in the DB' do
      include_examples 'responds with message', "You haven't added any words. Use /addword <word>"
    end
  end

  describe '#delword' do
    let!(:language) { create :language, name: 'Deutsch', slug: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }

    context 'with wrong parameter count' do
      subject { dispatch_message '/delword' }

      include_examples 'responds with message', 'Wrong arguments count. Usage: /delword <word>'
    end

    context 'with one parameter' do
      subject { dispatch_message '/delword eine' }

      context 'with known word' do
        let!(:word) { create :word, language: language, user: user, word: 'eine', translation: 'one' }

        include_examples 'responds with message', 'Word deleted: eine.'
        include_examples 'destroys', Word
      end

      context 'with unknown word' do
        include_examples 'responds with message', 'Unknown word: eine!'
      end
    end
  end

  describe 'context_handler :addword' do
    let!(:language) { create :language, name: 'Deutsch', slug: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }

    let!(:session) { { context: :addword, word: 'eine', translation: 'wrong' } }
    before { override_session(session) }

    subject { dispatch_message 'one' }

    include_examples 'creates new', Word
    include_examples 'responds with message', 'Word has been successfully added: eine - one'

    it 'cleans session' do
      subject
      expect(session).to be_empty
    end
  end

  describe '#callback_query', :callback_query do
    subject { dispatch callback_query: payload }

    let(:message) { { message_id: 22, chat: chat, text: 'message text' } }
    let(:payload) { { id: '11', from: from, message: message, data: data } }

    context 'with languages context' do
      let(:data) { 'de' }
      before { override_session(context: :languages) }

      context 'with existing user' do
        let!(:user) { create :user, user_id: 123 }

        context 'with valid language payload' do
          let!(:lang) { create :language, name: 'Deutsch', slug: 'de' }

          it 'update message and updates user\' lang' do
            expect { subject }.to edit_current_message(:text, text: 'Language changed: Deutsch')
            expect(user.reload.language).to eq(lang)
          end

          it 'cleans context' do
            subject
            expect(session[:context]).to be_nil
          end
        end

        context 'with invalid payload' do
          it 'update message with error' do
            expect { subject }.to edit_current_message(:text, text: 'Unknown language: de')
          end

          it 'cleans context' do
            subject
            expect(session[:context]).to be_nil
          end
        end
      end

      context 'with non-existing user' do
        it 'answers with valid response' do
          expect { subject }.to answer_callback_query('Sorry, you are not authorized, use /start')
        end
      end
    end

    context 'with word_confirmation context' do
      let!(:language) { create :language, name: 'Deutsch', slug: 'de' }
      let!(:user) { create :user, user_id: 123, language: language }
      before { override_session(context: :word_confirmation, word: 'eine', translation: 'one') }

      context 'with yes answer' do
        let(:data) { 'yes' }

        include_examples 'creates new', Word
        it 'edits the message' do
          expect { subject }.to edit_current_message(:text, text: 'Word has been successfully added: eine - one')
        end
      end

      context 'with no answer' do
        let(:data) { 'no' }

        include_examples 'does not create new', Word
        it 'edits the message' do
          expect { subject }.to edit_current_message(:text, text: 'Send me the valid translation')
        end
      end

      context 'with cancel answer' do
        let(:data) { 'cancel' }

        it 'edits the message' do
          expect { subject }.to edit_current_message(:text, text: 'Canceled')
        end
      end
    end
  end
end
