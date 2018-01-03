# frozen_string_literal: true

describe DbotController do
  describe '/languages workflow' do
    context 'with known user' do
      let!(:user) { create :user, user_id: 123 }

      context 'with existing languages' do
        let!(:lang1) { create :language, name: 'Deutsch', code: 'de' }
        let!(:lang2) { create :language, name: 'English', code: 'en' }

        it 'works as expected' do
          expect { dispatch_message '/languages' }.to send_telegram_message(bot,
                                                                            'Choose the language you will work with:',
                                                                            reply_markup: {
                                                                              inline_keyboard: [[
                                                                                { text: 'Deutsch', callback_data: 'languages:de' },
                                                                                { text: 'English', callback_data: 'languages:en' }
                                                                              ]]
                                                                            })

          expect { dispatch_callback_query('languages:de') }.to answer_callback_query_with('Language changed: Deutsch')
          expect(user.reload.language).to eq(lang1)
          expect { dispatch_callback_query('languages:en') }.to answer_callback_query_with('Language changed: English')
          expect(user.reload.language).to eq(lang2)
          expect { dispatch_callback_query('languages:unk') }.to answer_callback_query_with('Unknown language: unk')
          expect(user.reload.language).to eq(lang2)
        end
      end

      context 'with no languages in the DB' do
        it 'works as expected' do
          expect { dispatch_message '/languages' }.to respond_with_message 'Sorry, languages are not created yet!'
        end
      end
    end

    context 'with unknown user' do
      it 'works as expected' do
        expect { dispatch_message '/languages' }.to respond_with_message 'Sorry, you are not authorized, use /start'
      end
    end
  end
end
