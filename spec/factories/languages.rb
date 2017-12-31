# frozen_string_literal: true

FactoryBot.define do
  factory :language do
    name { Faker::Address.country }
    slug { Faker::Address.country_code }
  end
end
