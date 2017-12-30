# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:user_id)
    active true

    trait :inactive do
      active false
    end
  end
end
