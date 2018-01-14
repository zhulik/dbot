# frozen_string_literal: true

class Dictionaries::YandexWrapper < Dictionaries::Wrapper
  GEN_MAP = {
    'м' => 'm',
    'ж' => 'f',
    'ср' => 'n'
  }.freeze

  def variants
    @variants ||= raw.each_with_object([]) do |v, ary|
      v['tr'][0..1].each do |tr|
        ary << {
          word: @inverse ? tr['text'] : v['text'],
          translation: @inverse ? v['text'] : tr['text'],
          gen: @inverse ? GEN_MAP[v['gen']] : v['gen'],
          pos: v['pos']
        }
      end
    end[0..3]
  end

  def raw
    @raw ||= Yandex::Dictionary.lookup(@word, @from, @to, ui: 'en')
  end
end
