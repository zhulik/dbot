# frozen_string_literal: true

describe DbotController do
  let(:session) { {} }
  let!(:language) { create :language, name: 'Deutsch', code: 'de' }
  let!(:user) { create :user, user_id: 123, language: language }
  before { override_session(session) }

  describe '/practice pronounce' do
    it 'works as expected' do
      expect { dispatch_message '/pronounce' }.to send_telegram_message(bot, 'Send me the sentence')
      expect(session[:context]).to eq(:pronounce_send_sentence)
      VCR.use_cassette('voicerss', match_requests_on: [VCR.request_matchers.uri_without_param(:key)]) do
        expect {
          expect { dispatch_message 'Ich habe das Auto!' }.to make_telegram_request(bot, :sendVoice)
        }.to change(TtsPhrase, :count).by(1)
      end
      expect(session[:context]).to be_nil
    end
  end
end
