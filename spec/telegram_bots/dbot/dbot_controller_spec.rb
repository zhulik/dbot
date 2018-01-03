# frozen_string_literal: true

describe DbotController do
  describe '#callback_query', :callback_query do
    subject { dispatch callback_query: payload }

    let(:message) { { message_id: 22, chat: chat, text: 'message text' } }
    let(:payload) { { id: '11', from: from, message: message, data: data } }

    context 'with word_confirmation context' do
      let!(:language) { create :language, name: 'Deutsch', code: 'de' }
      let!(:user) { create :user, user_id: 123, language: language }
      before { override_session(context: :word_confirmation, word: { word: 'eins', translation: 'one' }) }

      context 'with yes answer' do
        let(:data) { 'yes' }

        include_examples 'creates new', Word
        it 'edits the message' do
          expect { subject }.to edit_current_message(:text, text: 'Word has been successfully added: eins - one')
        end
      end

      context 'with no answer' do
        let(:data) { 'no' }

        include_examples 'does not create new', Word
        it 'edits the message' do
          expect { subject }.to edit_current_message(:text, text: 'Send me the valid translation')
        end
      end

      context 'with cancel answer' do
        let(:data) { 'cancel' }

        it 'edits the message' do
          expect { subject }.to edit_current_message(:text, text: 'Canceled')
        end
      end
    end
  end
end
