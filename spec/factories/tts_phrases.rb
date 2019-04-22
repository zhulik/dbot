# frozen_string_literal: true

FactoryBot.define do
  factory :tts_phrase do
    phrase { 'MyString' }
    language { nil }
  end
end
