# frozen_string_literal: true

describe DbotController do
  describe '/practice workflow' do
    let(:session) { {} }
    let!(:language) { create :language, name: 'Deutsch', code: 'de' }
    let!(:user) { create :user, user_id: 123, language: language }
    let(:practices_keyboard) {
      [
        [{ text: 'Articles', callback_data: 'practice:articles' },
         { text: 'Prefixes', callback_data: 'practice:prefixes' }],
        [{ text: 'Foreign -> native practice', callback_data: 'practice:wordsfrom' },
         { text: 'Native -> foreign practice', callback_data: 'practice:wordsto' }]
      ]
    }
    before { override_session(session) }

    context 'with wordsfrom practice' do
      context 'when no words added' do
        it 'works as expected' do
          expect { dispatch_message '/practice' }.to send_telegram_message(bot,
                                                                           'What practice do you want?', reply_markup: {
                                                                             inline_keyboard: practices_keyboard
                                                                           })
          expect { dispatch_callback_query('practice:wordsfrom') }.to edit_current_message(:text, text: "You haven't added any words. Use /addword")
        end
      end

      context 'with word added' do
        let!(:w1) { create :word, user: user, language: language, word: 'word1', translation: 'translation', pos: 'noun', gen: 'm' }
        let!(:w2) { create :word, user: user, language: language, word: 'word2', translation: 'translation', pos: 'verb' }
        before do
          allow_any_instance_of(Words::WeighedRandom).to receive(:get).and_return(w1)
        end

        it 'works as expected' do
          expect { dispatch_message '/practice' }.to send_telegram_message(bot,
                                                                           'What practice do you want?', reply_markup: {
                                                                             inline_keyboard: practices_keyboard
                                                                           })
          expect {
            expect { dispatch_callback_query('practice:wordsfrom') }.to edit_current_message(:text, text: 'der Word1', reply_markup: {
                                                                                               inline_keyboard: [[
                                                                                                 { text: 'translation', callback_data: 'practice_wordsfrom:1:1' },
                                                                                                 { text: '✅ Finish', callback_data: 'practice_wordsfrom:finish' }
                                                                                               ]]
                                                                                             })
          }.to change(PracticeStat, :count).by(1)
          # Just the same, we have only one word
          expect { dispatch_callback_query('practice_wordsfrom:1:1') }.to edit_current_message(:text, text: 'der Word1', reply_markup: {
                                                                                                 inline_keyboard: [[
                                                                                                   { text: 'translation', callback_data: 'practice_wordsfrom:1:1' },
                                                                                                   { text: '✅ Finish', callback_data: 'practice_wordsfrom:finish' }
                                                                                                 ]]
                                                                                               })
          expect(w1.reload.practice_stats[:wordsfrom_success]).to eq(1)
          expect { dispatch_callback_query('practice_wordsfrom:1:1') }.to answer_callback_query_with('✅ word1 - translation')
          expect(w1.reload.practice_stats[:wordsfrom_success]).to eq(2)
          expect { dispatch_callback_query('practice_wordsfrom:1:2') }.to answer_callback_query_with('❎ word1 - translation ✅ word2 - translation')
          expect(w1.reload.practice_stats[:wordsfrom_fail]).to eq(1)
          expect(w2.reload.practice_stats[:wordsfrom_fail]).to eq(1)
          expect { dispatch_callback_query('practice_wordsfrom:finish') }.to edit_current_message(:text, text: 'Finished!')
        end
      end
    end

    context 'with wordsto practice' do
      context 'when no words added' do
        it 'works as expected' do
          expect { dispatch_message '/practice' }.to send_telegram_message(bot,
                                                                           'What practice do you want?', reply_markup: {
                                                                             inline_keyboard: practices_keyboard
                                                                           })
          expect { dispatch_callback_query('practice:wordsto') }.to edit_current_message(:text, text: "You haven't added any words. Use /addword")
        end
      end

      context 'with word added' do
        let!(:w1) { create :word, user: user, language: language, word: 'word1', translation: 'translation', pos: 'noun', gen: 'm' }

        it 'works as expected' do
          expect { dispatch_message '/practice' }.to send_telegram_message(bot,
                                                                           'What practice do you want?', reply_markup: {
                                                                             inline_keyboard: practices_keyboard
                                                                           })
          expect {
            expect { dispatch_callback_query('practice:wordsto') }.to edit_current_message(:text, text: 'translation', reply_markup: {
                                                                                             inline_keyboard: [[
                                                                                               { text: 'der Word1', callback_data: 'practice_wordsto:1:1' },
                                                                                               { text: '✅ Finish', callback_data: 'practice_wordsto:finish' }
                                                                                             ]]
                                                                                           })
          }.to change(PracticeStat, :count).by(1)

          # Just the same, we have only one word
          expect { dispatch_callback_query('practice_wordsto:1:1') }.to edit_current_message(:text, text: 'translation', reply_markup: {
                                                                                               inline_keyboard: [[
                                                                                                 { text: 'der Word1', callback_data: 'practice_wordsto:1:1' },
                                                                                                 { text: '✅ Finish', callback_data: 'practice_wordsto:finish' }
                                                                                               ]]
                                                                                             })
          expect(w1.reload.practice_stats[:wordsto_success]).to eq(1)
          expect { dispatch_callback_query('practice_wordsto:1:1') }.to answer_callback_query_with('✅ word1 - translation')
          expect { dispatch_callback_query('practice_wordsto:finish') }.to edit_current_message(:text, text: 'Finished!')
        end
      end
    end

    context 'with articles practice' do
      let!(:w1) { create :word, user: user, language: language, word: 'word1', translation: 'translation', pos: 'noun', gen: 'm' }

      it 'works as expected' do
        expect { dispatch_message '/practice' }.to send_telegram_message(bot,
                                                                         'What practice do you want?', reply_markup: {
                                                                           inline_keyboard: practices_keyboard
                                                                         })
        expect {
          expect { dispatch_callback_query('practice:articles') }.to edit_current_message(:text, text: 'word1',
                                                                                                 reply_markup: {
                                                                                                   inline_keyboard:
                                                                                                     [[
                                                                                                       { text: 'die', callback_data: 'practice_articles:1:die' },
                                                                                                       { text: 'der', callback_data: 'practice_articles:1:der' },
                                                                                                       { text: 'das', callback_data: 'practice_articles:1:das' }
                                                                                                     ],
                                                                                                      [{ text: '✅ Finish', callback_data: 'practice_articles:finish' }]]
                                                                                                 })
        }.to change(PracticeStat, :count).by(1)
        expect {
          expect { dispatch_callback_query('practice_articles:1:der') }.to answer_callback_query_with('✅ der Word1 - translation')
        }.to change { w1.reload.practice_stats[:articles_success] }.by(1)
        expect {
          expect { dispatch_callback_query('practice_articles:1:das') }.to answer_callback_query_with('❎ das is wrong ✅ der Word1 - translation')
        }.to change { w1.reload.practice_stats[:articles_fail] }.by(1)
        expect { dispatch_callback_query('practice_articles:finish') }.to edit_current_message(:text, text: 'Finished!')
      end
    end

    context 'with prefixes practice' do
      it 'works as expected' do
        expect { dispatch_message '/practice' }.to send_telegram_message(bot,
                                                                         'What practice do you want?', reply_markup: {
                                                                           inline_keyboard: practices_keyboard
                                                                         })
        allow_any_instance_of(PrefixesPractice).to receive(:prefix).and_return('ein')
        expect {
          expect { dispatch_callback_query('practice:prefixes') }.to edit_current_message(:text, text: 'ein',
                                                                                                 reply_markup: { inline_keyboard:
                                                                                                                   [[
                                                                                                                     { text: 'detachable', callback_data: 'practice_prefixes:ein:detachable' },
                                                                                                                     { text: 'undetachable', callback_data: 'practice_prefixes:ein:undetachable' },
                                                                                                                     { text: 'semi-detachable', callback_data: 'practice_prefixes:ein:semi-detachable' }
                                                                                                                   ],
                                                                                                                    [{ text: '✅ Finish', callback_data: 'practice_prefixes:finish' }]] })
        }.to change(PracticeStat, :count).by(1)
        expect { dispatch_callback_query('practice_prefixes:ein:detachable') }.to answer_callback_query_with('✅ ein - detachable')
        expect { dispatch_callback_query('practice_prefixes:ein:undetachable') }.to answer_callback_query_with('❎ undetachable is wrong ✅ ein - detachable')
        expect { dispatch_callback_query('practice_prefixes:finish') }.to edit_current_message(:text, text: "✅ Successes:\nein - 1\n❎ Fails:\nein - 1")
      end
    end
  end
end
