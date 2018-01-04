# frozen_string_literal: true

describe DbotController do
  describe 'message handling workflow' do
    let(:session) { {} }
    let!(:language) { create :language, name: 'Deutsch', code: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }
    before { override_session(session) }

    context 'with message in foreign language' do
      it 'works as expected' do
        VCR.use_cassette('yandex_dictionary_to_ru_Stuhl', match_requests_on: [VCR.request_matchers.uri_without_param(:key, :text)]) do
          expect { dispatch_message 'Stuhl' }.to send_telegram_message(bot,
                                                                       'What do you want to do with this text?',
                                                                       reply_markup: {
                                                                         inline_keyboard: [
                                                                           [{ text: 'Give feedback', callback_data: 'feedback:message' },
                                                                            { text: 'Translate', callback_data: 'translatefrom:message' }],
                                                                           [{ text: 'Pronounce', callback_data: 'pronounce:message' },
                                                                            { text: '❌ Cancel', callback_data: 'message:cancel' }],
                                                                           [{ text: 'Add word Stuhl', callback_data: 'addword:Stuhl' }]
                                                                         ]
                                                                       })
        end
        expect(session[:message_to_handle]).to eq('Stuhl')
        VCR.use_cassette('yandex_translator_de_ru_single', match_requests_on: [VCR.request_matchers.uri_without_param(:key)]) do
          expect { dispatch_callback_query('translatefrom:message') }.to edit_current_message(:text, text: 'Стул.', reply_markup: {
                                                                                                inline_keyboard: [
                                                                                                  [{ text: 'Add word Стул', callback_data: 'addword:Стул' },
                                                                                                   { text: '❌ Cancel', callback_data: 'addword:cancel' }]
                                                                                                ]
                                                                                              })
        end
        expect(session[:message_to_handle]).to be_nil

        VCR.use_cassette('yandex_dictionary_to_ru_Stuhl', match_requests_on: [VCR.request_matchers.uri_without_param(:key, :text)]) do
          expect { dispatch_message 'Stuhl' }.to send_telegram_message(bot,
                                                                       'What do you want to do with this text?',
                                                                       reply_markup: {
                                                                         inline_keyboard: [
                                                                           [{ text: 'Give feedback', callback_data: 'feedback:message' },
                                                                            { text: 'Translate', callback_data: 'translatefrom:message' }],
                                                                           [{ text: 'Pronounce', callback_data: 'pronounce:message' },
                                                                            { text: '❌ Cancel', callback_data: 'message:cancel' }],
                                                                           [{ text: 'Add word Stuhl', callback_data: 'addword:Stuhl' }]
                                                                         ]
                                                                       })
        end
        expect(session[:message_to_handle]).to eq('Stuhl')
        VCR.use_cassette('yandex_translator_de_ru_single', match_requests_on: [VCR.request_matchers.uri_without_param(:key)]) do
          expect { dispatch_callback_query('message:cancel') }.to edit_current_message(:text, text: 'Canceled')
        end
      end
    end

    context 'with message in native language' do
      it 'works as expected' do
        VCR.use_cassette('yandex_dictionary_to_ru_стул', match_requests_on: [VCR.request_matchers.uri_without_param(:key, :text)]) do
          expect { dispatch_message 'стул' }.to send_telegram_message(bot,
                                                                      'What do you want to do with this text?',
                                                                      reply_markup: {
                                                                        inline_keyboard: [
                                                                          [{ text: 'Give feedback', callback_data: 'feedback:message' },
                                                                           { text: 'Translate', callback_data: 'translateto:message' }],
                                                                          [{ text: 'Pronounce', callback_data: 'pronounce:message' },
                                                                           { text: '❌ Cancel', callback_data: 'message:cancel' }],
                                                                          [{ text: 'Add word стул', callback_data: 'addword:стул' }]
                                                                        ]
                                                                      })
          expect(session[:message_to_handle]).to eq('стул')
          VCR.use_cassette('yandex_translator_ru_de_single', match_requests_on: [VCR.request_matchers.uri_without_param(:key)]) do
            expect { dispatch_callback_query('translateto:message') }.to edit_current_message(:text, text: 'Stuhl.',
                                                                                                     reply_markup: { inline_keyboard: [
                                                                                                       [{ text: 'Add word Stuhl', callback_data: 'addword:Stuhl' },
                                                                                                        { text: '❌ Cancel', callback_data: 'addword:cancel' }]
                                                                                                     ] })
          end
          expect(session[:message_to_handle]).to be_nil
        end
      end
    end

    context 'with message in unknown language' do
      it 'works as expected' do
        VCR.use_cassette('yandex_dictionary_detect_unknown', match_requests_on: [VCR.request_matchers.uri_without_param(:key, :text)]) do
          expect { dispatch_message 'fewrwgfaf3qg' }.to respond_with_message 'Unknown or not configured language: cy! Your current_language: cy'
        end
      end
    end
  end
end
