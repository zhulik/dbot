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
        expect { dispatch_message '/delword' }.to respond_with_message "Send me the word's id"
        expect(session[:context]).to eq(:delword_send_word)
        expect {
          expect { dispatch_message word.id }.to respond_with_message 'Word deleted: eins.'
          expect(session[:context]).to be_nil
        }.to change(Word, :count).by(-1)
        expect { dispatch_message "/delword #{word.id}" }.to respond_with_message "Word with id #{word.id} is not found!"
      end
    end

    context 'with one parameter' do
      context 'with known word' do
        it 'works as expected' do
          expect {
            expect { dispatch_message "/delword #{word.id}" }.to respond_with_message 'Word deleted: eins.'
          }.to change(Word, :count).by(-1)
        end
      end
    end

    context 'with two parameters' do
      context 'with known word' do
        it 'works as expected' do
          expect { dispatch_message '/delword eins zvei' }.to respond_with_message "Wrong arguments count. Usage:\n/delword\n/delword <word_id>\n"
        end
      end
    end
  end
end
