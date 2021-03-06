# frozen_string_literal: true

FactoryBot.define do
  factory :word do
    language
    word { Faker::Lorem.word }
    translation { Faker::Lorem.word }
    pos { Word.pos.keys.sample }
    gen { Word.gens.keys.sample }
  end
end
