# frozen_string_literal: true

RSpec.shared_examples 'responds with message' do |message|
  it 'responds with valid message' do
    expect { subject }.to respond_with_message message
  end
end

RSpec.shared_context 'telegram/bot/session' do
  def override_session(session)
    allow_any_instance_of(described_class).to receive(:session).and_return(session)
  end
end
