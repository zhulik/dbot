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
    end
  end
end
