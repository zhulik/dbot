# frozen_string_literal: true

FactoryBot.define do
  factory :word do
    word { Faker::Lorem.word }
    translation { Faker::Lorem.word }
  end
end
