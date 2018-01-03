# frozen_string_literal: true

class Dictionaries::YandexWrapper < Dictionaries::Wrapper
  def variants
    @variants ||= raw.each_with_object([]) do |v, ary|
      v['tr'][0..1].each do |tr|
        ary << {
          word: v['text'],
          translation: tr['text'],
          gen: v['gen'],
          pos: v['pos']
        }
      end
    end[0..3]
  end

  def raw
    @raw ||= Yandex::Dictionary.lookup(@word, @from, @to)
  end
end
