# frozen_string_literal: true

describe DbotController do
  describe '/delword workflow' do
    let!(:language) { create :language, name: 'Deutsch', code: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }
    let!(:word) { create :word, language: language, user: user, word: 'eins', translation: 'one' }
    let(:session) { {} }
    before { override_session(session) }

    context 'without parameters' do
      it 'works as expected' do
        expect { dispatch_message '/delword' }.to respond_with_message 'Send me the word'
        expect(session[:context]).to eq(:delword_send_word)
        expect {
          expect { dispatch_message 'eins' }.to respond_with_message 'Word deleted: eins.'
          expect(session[:context]).to be_nil
        }.to change(Word, :count).by(-1)
        expect { dispatch_message '/delword eins' }.to respond_with_message 'Unknown word: eins!'
      end
    end

    context 'with one parameter' do
      context 'with known word' do
        it 'works as expected' do
          expect {
            expect { dispatch_message '/delword eins' }.to respond_with_message 'Word deleted: eins.'
          }.to change(Word, :count).by(-1)
        end
      end
    end
  end
end
