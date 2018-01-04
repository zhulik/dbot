# frozen_string_literal: true

describe DbotController do
  describe '/words workflow' do
    let!(:language) { create :language, name: 'Deutsch', code: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }

    context 'with existing words' do
      let!(:word) { create :word, language: language, user: user, word: 'word', translation: 'translation', pos: 'noun', gen: 'm' }

      it 'works as expected' do
        expect { dispatch_message '/words' }.to respond_with_message "Your saved words:\nword - translation noun m"
      end
    end

    context 'with no words in the DB' do
      it 'works as expected' do
        expect { dispatch_message '/words' }.to respond_with_message "You haven't added any words. Use /addword <word>"
      end
    end
  end
end
