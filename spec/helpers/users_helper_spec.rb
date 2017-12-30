# frozen_string_literal: true

describe ApplicationHelper do
  describe '#user_greeting' do
    subject { helper.user_greeting(user) }

    context 'with no data available' do
      let(:user) { Telegram::Bot::Types::User.new }

      it 'returns "my friend"' do
        expect(subject).to eq('my friend')
      end
    end

    context 'with username passed' do
      let(:user) { Telegram::Bot::Types::User.new(username: 'user') }

      it 'returns username' do
        expect(subject).to eq('user')
      end
    end

    context 'with only first_name and username passed' do
      let(:user) { Telegram::Bot::Types::User.new(first_name: 'John', username: 'user') }

      it 'returns username' do
        expect(subject).to eq('user')
      end
    end

    context 'with first_name, last name and username passed ' do
      let(:user) { Telegram::Bot::Types::User.new(first_name: 'John', last_name: 'Smith', username: 'user') }

      it 'returns name' do
        expect(subject).to eq('John Smith')
      end
    end
  end
end
