# frozen_string_literal: true

describe DbotController do
  describe '/translatefrom workflow' do
    context 'without selected language' do
      let!(:user) { create :user, user_id: 123 }

      it 'works as expected' do
        expect { dispatch_message '/translatefrom' }.to respond_with_message 'Language is not selected. Use /languages'
      end
    end

    context ' with selected language' do
      let(:session) { {} }
      let!(:language) { create :language, name: 'Deutsch', code: 'de' }
      let!(:user) { create :user, user_id: 123, language: language }
      before { override_session(session) }

      context 'with no arguments passed' do
        it 'works as expected' do
          expect { dispatch_message '/translatefrom' }.to respond_with_message 'Send me the sentence'
          expect(session[:context]).to eq(:translatefrom_send_sentence)
          VCR.use_cassette('yandex_translator_ru_de') do
            expect { dispatch_message 'Ich esse.' }.to respond_with_message 'Я ем.'
          end
          expect(session[:context]).to be_nil
        end
      end

      context 'with sentence passed' do
        it 'works as expected' do
          VCR.use_cassette('yandex_translator_ru_de') do
            expect { dispatch_message '/translatefrom Ich esse.' }.to respond_with_message 'Я ем.'
          end
          expect(session[:context]).to be_nil
        end
      end

      context 'with only one word passed' do
        it 'works as expected' do
          VCR.use_cassette('yandex_translator_de_ru_single') do
            expect { dispatch_message '/translatefrom Stuhl.' }.to send_telegram_message(bot,
                                                                                         'Стул.',
                                                                                         reply_markup: {
                                                                                           inline_keyboard: [[
                                                                                             { text: 'Add word Стул', callback_data: 'addword:Стул' }
                                                                                           ]]
                                                                                         })
          end
          VCR.use_cassette('yandex_dictionary_from_ru_стул', match_requests_on: [:method, VCR.request_matchers.uri_without_param(:key, :text)]) do
            expect { dispatch_callback_query('addword:Стул') }.to edit_current_message(:text, text: 'Choose right variant:',
                                                                                              reply_markup: {
                                                                                                inline_keyboard: [
                                                                                                  [{ text: 'Stuhl - стул noun m', callback_data: 'addword_choose:0' }],
                                                                                                  [{ text: 'Stuhlgang - стул noun m', callback_data: 'addword_choose:1' }],
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
