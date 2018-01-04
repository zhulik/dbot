# frozen_string_literal: true

describe DbotController do
  describe '/translateto workflow' do
    context 'without selected language' do
      let!(:user) { create :user, user_id: 123 }

      it 'works as expected' do
        expect { dispatch_message '/translateto' }.to respond_with_message 'Language is not selected. Use /languages'
      end
    end

    context ' with selected language' do
      let(:session) { {} }
      let!(:language) { create :language, name: 'Deutsch', code: 'de' }
      let!(:user) { create :user, user_id: 123, language: language }
      before { override_session(session) }

      context 'with no arguments passed' do
        it 'works as expected' do
          expect { dispatch_message '/translateto' }.to respond_with_message 'Send me the sentence'
          expect(session[:context]).to eq(:translateto_send_sentence)
          VCR.use_cassette('yandex_translator_de_ru') do
            expect { dispatch_message 'Я ем.' }.to respond_with_message 'Ich esse.'
          end
          expect(session[:context]).to be_nil
        end
      end

      context 'with sentence passed' do
        it 'works as expected' do
          VCR.use_cassette('yandex_translator_de_ru') do
            expect { dispatch_message '/translateto Я ем.' }.to respond_with_message 'Ich esse.'
          end
          expect(session[:context]).to be_nil
        end
      end

      context 'with only one word passed' do
        it 'works as expected' do
          VCR.use_cassette('yandex_translator_ru_de_single') do
            expect { dispatch_message '/translateto Стул.' }.to send_telegram_message(bot,
                                                                                      'Stuhl.',
                                                                                      reply_markup: {
                                                                                        inline_keyboard: [[
                                                                                          { text: 'Add word Stuhl', callback_data: 'addword:Stuhl' },
                                                                                          { text: '❌ Cancel', callback_data: 'addword:cancel' }
                                                                                        ]]
                                                                                      })
          end
          VCR.use_cassette('yandex_dictionary_to_ru_Stuhl', match_requests_on: [VCR.request_matchers.uri_without_param(:key, :text)]) do
            expect { dispatch_callback_query('addword:Stuhl') }.to edit_current_message(:text, text: 'Choose right variant:',
                                                                                               reply_markup: {
                                                                                                 inline_keyboard: [
                                                                                                   [{ text: 'Stuhl - стул noun m', callback_data: 'addword_choose:0' }],
                                                                                                   [{ text: 'Stuhl - Святой Престол noun m', callback_data: 'addword_choose:1' }],
                                                                                                   [{ text: '❌ Cancel', callback_data: 'addword_choose:cancel' }, { text: 'Custom variant', callback_data: 'addword_choose:custom_variant' }]
                                                                                                 ]
                                                                                               })
          end
          # tested in addword workflow specs
        end
      end
    end
  end
end
