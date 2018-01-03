# frozen_string_literal: true

describe DbotController do
  describe '/delword workflow' do
    let!(:language) { create :language, name: 'Deutsch', code: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }

    context 'with wrong parameter count' do
      it 'works as expected' do
        expect { dispatch_message '/delword' }.to respond_with_message 'Wrong arguments count. Usage: /delword <word>'
      end
    end

    context 'with one parameter' do
      context 'with known word' do
        let!(:word) { create :word, language: language, user: user, word: 'eins', translation: 'one' }

        it 'works as expected' do
          expect {
            expect { dispatch_message '/delword eins' }.to respond_with_message 'Word deleted: eins.'
          }.to change(Word, :count).by(-1)
        end
      end

      context 'with unknown word' do
        it 'works as expected' do
          expect {
            expect { dispatch_message '/delword eins' }.to respond_with_message 'Unknown word: eins!'
          }.not_to change(Word, :count)
        end
      end
    end
  end
end
