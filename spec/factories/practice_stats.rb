# frozen_string_literal: true

FactoryBot.define do
  factory :practice_stat do
    user { nil }
    practice { 'wordsto' }
    status { 'in_progress' }
    stats { nil }
    sequence(:message_id)
    sequence(:chat_id)
  end
end
