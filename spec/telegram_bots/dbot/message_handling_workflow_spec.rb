# frozen_string_literal: true

describe DbotController do
  describe 'message handling workflow' do
    let(:session) { {} }
    let!(:language) { create :language, name: 'Deutsch', code: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }
    before { override_session(session) }

    context 'with message in foreign language' do
      it 'works as expected' do
        VCR.use_cassette('yandex_dictionary_to_ru_Stuhl', match_requests_on: [:method, VCR.request_matchers.uri_without_param(:key, :text)]) do
          expect { dispatch_message 'Stuhl' }.to respond_with_message 'Language is not selected. Use /languages'
        end
      end
    end

    context 'with message in native language' do
      it 'works as expected' do
        VCR.use_cassette('yandex_dictionary_to_ru_стул', match_requests_on: [:method, VCR.request_matchers.uri_without_param(:key, :text)]) do
          expect { dispatch_message 'стул' }.to respond_with_message 'Language is not selected. Use /languages'
        end
      end
    end

    context 'with message in unknown language' do
      it 'works as expected' do
        VCR.use_cassette('yandex_dictionary_detect_unknown', match_requests_on: [:method, VCR.request_matchers.uri_without_param(:key, :text)]) do
          expect { dispatch_message 'fewrwgfaf3qg' }.to respond_with_message 'Unknown or not configured language: cy! Your current_language: cy'
        end
      end
    end
  end
end
