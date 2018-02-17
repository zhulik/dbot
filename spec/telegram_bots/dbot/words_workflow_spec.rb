# frozen_string_literal: true

describe DbotController do
  describe '/words workflow' do
    let!(:language) { create :language, name: 'Deutsch', code: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }

    context 'with existing words' do
      let!(:word) { create :word, language: language, user: user, word: 'word', translation: 'translation', pos: 'noun', gen: 'm' }

      it 'works as expected' do
        expect { dispatch_message '/words' }.to respond_with_message "Your saved words:\nder Word - translation noun m\nPage 1 of 1. Total count: 1"
        expect { dispatch_callback_query('words:page:1') }.to edit_current_message :text, text: "Your saved words:\nder Word - translation noun m\nPage 1 of 1. Total count: 1"
      end
    end

    context 'with no words in the DB' do
      it 'works as expected' do
        expect { dispatch_message '/words' }.to respond_with_message "You haven't added any words. Use /addword"
      end
    end
  end
end
