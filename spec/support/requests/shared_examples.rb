# frozen_string_literal: true

RSpec.shared_examples 'responds with message' do |message|
  it 'responds with valid message' do
    expect { subject }.to respond_with_message message
  end
end
