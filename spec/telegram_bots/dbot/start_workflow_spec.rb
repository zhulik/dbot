# frozen_string_literal: true

describe DbotController do
  describe '/start workflow' do
    context 'with new user' do
      it 'works as expected' do
        expect {
          expect { dispatch_message '/start' }.to respond_with_message 'Hi, my friend! Use /start to choose target language.'
        }.to change(User, :count).by 1
      end
    end

    context 'with existing' do
      context 'active user' do
        let!(:user) { create :user, user_id: 123 }

        it 'works as expected' do
          expect {
            expect { dispatch_message '/start' }.to respond_with_message 'We have already started!'
          }.not_to change(User, :count)
        end
      end

      context 'inactive user' do
        let!(:user) { create :user, :inactive, user_id: 123 }

        it 'works as expected' do
          expect {
            expect { dispatch_message '/start' }.to respond_with_message 'Your subscription has been reactivated!'
          }.not_to change(User, :count)
          expect(user.reload).to be_active
        end
      end
    end
  end
end
