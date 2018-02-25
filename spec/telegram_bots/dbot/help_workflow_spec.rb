# frozen_string_literal: true

describe DbotController do
  describe '/help' do
    let!(:language) { create :language, name: 'Deutsch', code: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }

    it 'works as expected' do
      expect { dispatch_message '/help' }.to respond_with_message "/addword - Add word to the dictionary\n/delword - Delete word from dictionary\n/help - This help message\n/languages - List and select languages.\n/practice - Start practicing\n/pronounce - Pronounce text\n/start - Start working with bot\n/translatefrom - Translate from foreign language\n/translateto - Translate to foreign language\n/words - List saved words."
    end
  end
end
