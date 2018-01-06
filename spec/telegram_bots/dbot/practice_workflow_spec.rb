# frozen_string_literal: true

describe DbotController do
  describe '/practice workflow' do
    let(:session) { {} }
    let!(:language) { create :language, name: 'Deutsch', code: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }
    before { override_session(session) }

    context 'when no words added' do
      it 'works as expected' do
        expect { dispatch_message '/practice' }.to send_telegram_message(bot,
                                                                         'What practice do you want?', reply_markup: {
                                                                           inline_keyboard: [[
                                                                             { text: 'Words practice', callback_data: 'practice:wordsfrom' }
                                                                           ]]
                                                                         })
        expect { dispatch_callback_query('practice:wordsfrom') }.to edit_current_message(:text, text: "You haven't added any words. Use /addword")
      end
    end

    context 'with word added' do
      let!(:word) { create :word, user: user, language: language, word: 'word', translation: 'translation', pos: 'noun', gen: 'm' }

      it 'words as expected' do
        expect { dispatch_message '/practice' }.to send_telegram_message(bot,
                                                                         'What practice do you want?', reply_markup: {
                                                                           inline_keyboard: [[
                                                                             { text: 'Words practice', callback_data: 'practice:wordsfrom' }
                                                                           ]]
                                                                         })
        expect { dispatch_callback_query('practice:wordsfrom') }.to edit_current_message(:text, text: 'der Word', reply_markup: {
                                                                                           inline_keyboard: [[
                                                                                             { text: 'translation', callback_data: 'wordsfrom_practice:1:1' },
                                                                                             { text: '❌ Cancel', callback_data: 'wordsfrom_practice:cancel' }
                                                                                           ]]
                                                                                         })
        # Just the same, we have only one word
        expect { dispatch_callback_query('wordsfrom_practice:1:1') }.to edit_current_message(:text, text: 'der Word', reply_markup: {
                                                                                               inline_keyboard: [[
                                                                                                 { text: 'translation', callback_data: 'wordsfrom_practice:1:1' },
                                                                                                 { text: '❌ Cancel', callback_data: 'wordsfrom_practice:cancel' }
                                                                                               ]]
                                                                                             })
        expect(word.reload.wordsfrom_success).to eq(1)
        expect { dispatch_callback_query('wordsfrom_practice:1:1') }.to answer_callback_query_with('✅ word - translation')
        expect(word.reload.wordsfrom_success).to eq(2)
        expect { dispatch_callback_query('wordsfrom_practice:1:2') }.to answer_callback_query_with('❎ word - translation')
        expect(word.reload.wordsfrom_fail).to eq(1)
        expect { dispatch_callback_query('wordsfrom_practice:cancel') }.to edit_current_message(:text, text: 'Canceled')
      end
    end
  end
end
