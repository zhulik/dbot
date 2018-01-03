# frozen_string_literal: true

describe DbotController do
  describe '#addword' do
    let!(:session) { {} }
    before do
      override_session(session)
    end

    context 'with existing user' do
      let!(:language) { create :language, name: 'Deutsch', code: 'de' }
      let!(:user) { create :user, user_id: 123, language: language }

      context 'without arguments' do
        subject { dispatch_message '/addword' }
        include_examples 'responds with message', 'Wrong arguments count. Usage: /addword <word> [translation]'
      end

      context 'with one argument' do
        subject { dispatch_message '/addword eins' }
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
            expect(session[:word]).to eq(word: 'eins', translation: 'один')
          end
        end

        context 'with known word' do
          let!(:word) { create :word, word: 'eins', translation: 'one', user: user, language: language }

          include_examples 'responds with message', 'Word eins is already added!'
        end
      end

      context 'with two arguments' do
        subject { dispatch_message '/addword eins one' }

        include_examples 'creates new', Word
        include_examples 'responds with message', 'Word has been successfully added: eins - one'

        it 'creates valid word' do
          subject
          word = Word.last
          expect(word.word).to eq('eins')
          expect(word.translation).to eq('one')
        end
      end

      context 'with many arguments' do
        subject { dispatch_message '/addword test test test' }
        include_examples 'responds with message', 'Wrong arguments count. Usage: /addword <word> [translation]'
      end
    end

    context 'with non-existing user' do
      subject { dispatch_message '/addword eins' }

      include_examples 'responds with message', 'Sorry, you are not authorized, use /start'
    end

    describe 'context_handler :addword' do
      let!(:language) { create :language, name: 'Deutsch', code: 'de' }
      let!(:user) { create :user, user_id: 123, language: language }

      let!(:session) { { context: :addword, word: { word: 'eins', translation: 'wrong' } } }
      before { override_session(session) }

      subject { dispatch_message 'one' }

      include_examples 'creates new', Word
      include_examples 'responds with message', 'Word has been successfully added: eins - one'

      it 'cleans session' do
        subject
        expect(session).to be_empty
      end
    end
  end
end
