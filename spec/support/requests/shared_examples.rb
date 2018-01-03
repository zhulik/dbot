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

RSpec.shared_context 'telegram/bot/callback_query_helpers' do
  def dispatch_callback_query(data)
    dispatch callback_query: { id: '11', from: from, message: message, data: data }
  end

  def answer_callback_query_with(text = Regexp.new(''), options = {})
    description = "answer callback query with #{text.inspect}"
    text = a_string_matching(text) if text.is_a?(Regexp)
    options = options.merge(
      callback_query_id: '11',
      text: text
    )
    Telegram::Bot::RSpec::ClientMatchers::MakeTelegramRequest.new(
      bot, :answerCallbackQuery, description: description
    ).with(hash_including(options))
  end
end
