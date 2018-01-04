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
    end
  end
end
