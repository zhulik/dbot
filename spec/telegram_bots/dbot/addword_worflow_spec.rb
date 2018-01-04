# frozen_string_literal: true

describe DbotController do
  describe '/addword workflow' do
    context 'without selected language' do
      let!(:user) { create :user, user_id: 123 }

      it 'works as expected' do
        expect { dispatch_message '/addword test' }.to respond_with_message 'Language is not selected. Use /languages'
      end
    end

    context ' with selected language' do
      let(:session) { {} }
      let!(:language) { create :language, name: 'Deutsch', code: 'de' }
      let!(:user) { create :user, user_id: 123, language: language }
      before { override_session(session) }

      context 'with no arguments passed' do
        context 'with word in target language' do
          it 'works as expected' do
            expect { dispatch_message '/addword' }.to respond_with_message 'Send me the word'
            expect(session[:context]).to eq(:addword_send_word)
            VCR.use_cassette('yandex_dictionary_from_de_Stuhl', match_requests_on: [VCR.request_matchers.uri_without_param(:key)]) do
              expect { dispatch_message 'Stuhl' }.to send_telegram_message(bot,
                                                                           'Choose right variant:',
                                                                           reply_markup: {
                                                                             inline_keyboard: [
                                                                               [{ text: 'Stuhl - стул noun m', callback_data: 'addword_choose:0' }],
                                                                               [{ text: 'Stuhl - Святой Престол noun m', callback_data: 'addword_choose:1' }],
                                                                               [{ text: '❌ Cancel', callback_data: 'addword_choose:cancel' }, { text: 'Custom variant', callback_data: 'addword_choose:custom_variant' }]
                                                                             ]
                                                                           })
            end
            expect(session[:context]).to be_nil
            expect(session[:addword_variants]).to eq([{ word: 'Stuhl', translation: 'стул', gen: 'm', pos: 'noun' },
                                                      { word: 'Stuhl', translation: 'Святой Престол', gen: 'm', pos: 'noun' }])
            expect {
              expect { dispatch_callback_query('addword_choose:0') }.to edit_current_message(:text, text: 'Word has been successfully added: Stuhl - стул')
              expect(session[:context]).to be_nil
              expect(session[:addword_variants]).to be_nil
              expect(session[:addword_word]).to be_nil
            }.to change(Word, :count).by(1)
            expect(Word.last).to have_attributes(word: 'Stuhl', translation: 'стул', pos: 'noun', gen: 'm')
          end
        end

        context 'with word in native language' do
          it 'works as expected' do
            expect { dispatch_message '/addword' }.to respond_with_message 'Send me the word'
            expect(session[:context]).to eq(:addword_send_word)
            VCR.use_cassette('yandex_dictionary_from_ru_стул', match_requests_on: [VCR.request_matchers.uri_without_param(:key)]) do
              expect { dispatch_message 'стул' }.to send_telegram_message(bot,
                                                                          'Choose right variant:',
                                                                          reply_markup: {
                                                                            inline_keyboard: [
                                                                              [{ text: 'Stuhl - стул noun m', callback_data: 'addword_choose:0' }],
                                                                              [{ text: 'Stuhlgang - стул noun m', callback_data: 'addword_choose:1' }],
                                                                              [{ text: '❌ Cancel', callback_data: 'addword_choose:cancel' }, { text: 'Custom variant', callback_data: 'addword_choose:custom_variant' }]
                                                                            ]
                                                                          })
            end
            expect(session[:context]).to be_nil
            expect(session[:addword_variants]).to eq([{ word: 'Stuhl', translation: 'стул', gen: 'm', pos: 'noun' },
                                                      { word: 'Stuhlgang', translation: 'стул', gen: 'm', pos: 'noun' }])
            expect {
              expect { dispatch_callback_query('addword_choose:0') }.to edit_current_message(:text, text: 'Word has been successfully added: Stuhl - стул')
              expect(session[:context]).to be_nil
              expect(session[:addword_variants]).to be_nil
              expect(session[:addword_word]).to be_nil
            }.to change(Word, :count).by(1)
            expect(Word.last).to have_attributes(word: 'Stuhl', translation: 'стул', pos: 'noun', gen: 'm')
          end
        end
      end

      context 'with one argument passed' do
        context 'when chose custom translation' do
          context 'with word in target language' do
            it 'works as expected' do
              VCR.use_cassette('yandex_dictionary_from_ru_стул', match_requests_on: [VCR.request_matchers.uri_without_param(:key)]) do
                expect { dispatch_message '/addword стул' }.to send_telegram_message(bot,
                                                                                     'Choose right variant:',
                                                                                     reply_markup: {
                                                                                       inline_keyboard: [
                                                                                         [{ text: 'Stuhl - стул noun m', callback_data: 'addword_choose:0' }],
                                                                                         [{ text: 'Stuhlgang - стул noun m', callback_data: 'addword_choose:1' }],
                                                                                         [{ text: '❌ Cancel', callback_data: 'addword_choose:cancel' }, { text: 'Custom variant', callback_data: 'addword_choose:custom_variant' }]
                                                                                       ]
                                                                                     })
                expect(session[:addword_variants]).to eq([{ word: 'Stuhl', translation: 'стул', gen: 'm', pos: 'noun' },
                                                          { word: 'Stuhlgang', translation: 'стул', gen: 'm', pos: 'noun' }])
                expect(session[:addword_word]).to eq('стул')
                expect(session[:addword_inverse]).to be_truthy
                expect { dispatch_callback_query('addword_choose:custom_variant') }.to edit_current_message(:text, text: 'Send me the valid translation')
                expect(session[:context]).to eq(:addword_custom_variant)
                expect {
                  expect { dispatch_message 'Stuhl noun m' }.to respond_with_message 'Word has been successfully added: Stuhl - стул'
                  expect(session[:context]).to be_nil
                  expect(session[:addword_variants]).to be_nil
                  expect(session[:addword_word]).to be_nil
                }.to change(Word, :count).by(1)
                expect(Word.last).to have_attributes(word: 'Stuhl', translation: 'стул', pos: 'noun', gen: 'm')
              end
            end
          end
        end

        context 'when chose cancel' do
          it 'works as expected' do
            VCR.use_cassette('yandex_dictionary_from_de_Stuhl', match_requests_on: [VCR.request_matchers.uri_without_param(:key)]) do
              expect { dispatch_message '/addword Stuhl' }.to send_telegram_message(bot,
                                                                                    'Choose right variant:',
                                                                                    reply_markup: {
                                                                                      inline_keyboard: [
                                                                                        [{ text: 'Stuhl - стул noun m', callback_data: 'addword_choose:0' }],
                                                                                        [{ text: 'Stuhl - Святой Престол noun m', callback_data: 'addword_choose:1' }],
                                                                                        [{ text: '❌ Cancel', callback_data: 'addword_choose:cancel' }, { text: 'Custom variant', callback_data: 'addword_choose:custom_variant' }]
                                                                                      ]
                                                                                    })
              expect(session[:addword_variants]).to eq([{ word: 'Stuhl', translation: 'стул', gen: 'm', pos: 'noun' },
                                                        { word: 'Stuhl', translation: 'Святой Престол', gen: 'm', pos: 'noun' }])
              expect(session[:addword_word]).to eq('Stuhl')
              expect { dispatch_callback_query('addword_choose:cancel') }.to edit_current_message(:text, text: 'Canceled')
              expect(session[:context]).to be_nil
              expect(session[:addword_variants]).to be_nil
              expect(session[:addword_word]).to be_nil
            end
          end
        end
      end

      context 'with two arguments passed' do
        it 'works as expected' do
          expect { dispatch_message '/addword Stuhl стул' }.to respond_with_message "Wrong arguments count. Usage:\n/addword\n/addword <word>\n/addword <word> <translation> <pos>\n/addword <word> <translation> <pos> <gen>\n"
          expect(session[:context]).to be_nil
          expect(session[:addword_variants]).to be_nil
          expect(session[:addword_word]).to be_nil
        end
      end

      context 'with three or four arguments passed' do
        it 'works as expected' do
          expect {
            expect { dispatch_message '/addword Stuhl стул noun' }.to respond_with_message 'Word has been successfully added: Stuhl - стул'
            expect { dispatch_message '/addword Tisch стол noun m' }.to respond_with_message 'Word has been successfully added: Tisch - стол'
            expect { dispatch_message '/addword Katze кошка wrong' }.to respond_with_message 'Unknown pos: wrong. Valid are: noun, verb, adjective, adverb, pronoun, preposition, conjunction, numeral'
            expect { dispatch_message '/addword Katze кошка noun x' }.to respond_with_message 'Unknown gen: x. Valid are: f, m, n'
          }.to change(Word, :count).by(2)
          expect(session[:context]).to be_nil
          expect(session[:addword_variants]).to be_nil
          expect(session[:addword_word]).to be_nil
        end
      end

      context 'with five arguments passed' do
        it 'works as expected' do
          expect { dispatch_message '/addword 1 2 3 4 5' }.to respond_with_message "Wrong arguments count. Usage:\n/addword\n/addword <word>\n/addword <word> <translation> <pos>\n/addword <word> <translation> <pos> <gen>\n"
          expect(session[:context]).to be_nil
          expect(session[:addword_variants]).to be_nil
          expect(session[:addword_word]).to be_nil
        end
      end
    end
  end
end
