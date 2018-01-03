# frozen_string_literal: true

describe Dictionaries::YandexWrapper do
  describe '#variants' do
    context 'with from==de' do
      let!(:from_lang) { 'de' }

      VARIANTS = {
        'Stuhl': [{ word: 'Stuhl', translation: 'стул', gen: 'm', pos: 'noun' },
                  { word: 'Stuhl', translation: 'Святой Престол', gen: 'm', pos: 'noun' }],
        'haben': [{ word: 'haben', translation: 'иметь', gen: nil, pos: 'verb' },
                  { word: 'haben', translation: 'обладать', gen: nil, pos: 'verb' },
                  { word: 'Haben', translation: 'кредит', gen: nil, pos: 'noun' },
                  { word: 'Haben', translation: 'приход', gen: nil, pos: 'noun' }],
        'sein': [{ word: 'sein', translation: 'являться', gen: nil, pos: 'verb' },
                 { word: 'sein', translation: 'случаться', gen: nil, pos: 'verb' },
                 { word: 'sein', translation: 'его', gen: nil, pos: 'determiner' },
                 { word: 'sein', translation: 'свой', gen: nil, pos: 'determiner' }],
        'Frau': [{ word: 'Frau', translation: 'женщина', gen: 'f', pos: 'noun' },
                 { word: 'Frau', translation: 'госпожа', gen: 'f', pos: 'noun' }],
        'Fenster': [{ word: 'Fenster', translation: 'окно', gen: 'n', pos: 'noun' },
                    { word: 'Fenster', translation: 'фрейм', gen: 'n', pos: 'noun' }],
        'er': [{ word: 'er', translation: 'они', gen: nil, pos: 'pronoun' },
               { word: 'er', translation: 'он', gen: nil, pos: 'pronoun' }],
        'gross': [{ word: 'groß', translation: 'большой', gen: nil, pos: 'adjective' },
                  { word: 'groß', translation: 'широкий', gen: nil, pos: 'adjective' },
                  { word: 'groß', translation: 'крупно', gen: nil, pos: 'adverb' }],
        'zwanzig': [{ word: 'zwanzig', translation: 'двадцать', gen: nil, pos: 'numeral' }],
        'xyz': []
      }.freeze

      VARIANTS.each do |word, variants|
        it "returns valid variants for #{word}" do
          VCR.use_cassette("yandex_dictionary_from_#{from_lang}_#{word}") do
            v = described_class.new(word, from: from_lang, to: 'ru').variants
            expect(v).to eq(variants)
          end
        end
      end
    end

    context 'with from==en' do
      let!(:from_lang) { 'en' }

      VARIANTS = {
        'chair': [{ word: 'chair', translation: 'стул', gen: nil, pos: 'noun' },
                  { word: 'chair', translation: 'кафедра', gen: nil, pos: 'noun' },
                  { word: 'chair', translation: 'председательствовать', gen: nil, pos: 'verb' },
                  { word: 'chair', translation: 'кресельный', gen: nil, pos: 'adjective' }],
        'have': [{ word: 'have', translation: 'иметь', gen: nil, pos: 'verb' },
                 { word: 'have', translation: 'обладать', gen: nil, pos: 'verb' },
                 { word: 'have', translation: 'уже', gen: nil, pos: 'adverb' },
                 { word: 'have', translation: 'вспомогательный глагол', gen: nil, pos: 'noun' }],
        'be': [{ word: 'be', translation: 'быть', gen: nil, pos: 'verb' },
               { word: 'be', translation: 'происходить', gen: nil, pos: 'verb' },
               { word: 'be', translation: 'равно', gen: nil, pos: 'adjective' }],
        'woman': [{ word: 'woman', translation: 'женщина', gen: nil, pos: 'noun' },
                  { word: 'woman', translation: 'женский пол', gen: nil, pos: 'noun' },
                  { word: 'woman', translation: 'женский', gen: nil, pos: 'adjective' }],
        'window': [{ word: 'window', translation: 'окно', gen: nil, pos: 'noun' },
                   { word: 'window', translation: 'витрина', gen: nil, pos: 'noun' },
                   { word: 'window', translation: 'оконный', gen: nil, pos: 'adjective' },
                   { word: 'window', translation: 'Window', gen: nil, pos: nil }],
        'he': [{ word: 'he', translation: 'он', gen: nil, pos: 'pronoun' }],
        'big': [{ word: 'big', translation: 'большой', gen: nil, pos: 'adjective' },
                { word: 'big', translation: 'важный', gen: nil, pos: 'adjective' },
                { word: 'big', translation: 'много', gen: nil, pos: 'numeral' },
                { word: 'big', translation: 'Биг', gen: nil, pos: 'noun' }],
        'twenty': [{ word: 'twenty', translation: 'двадцать', gen: nil, pos: 'numeral' },
                   { word: 'twenty', translation: 'двадцатый', gen: nil, pos: 'numeral' },
                   { word: 'twenty', translation: 'два десятка', gen: nil, pos: 'noun' },
                   { word: 'twenty', translation: 'двадцатка', gen: nil, pos: 'noun' }],
        'xyz': []
      }.freeze

      VARIANTS.each do |word, variants|
        it "returns valid variants for #{word}" do
          VCR.use_cassette("yandex_dictionary_from_#{from_lang}_#{word}") do
            v = described_class.new(word, from: from_lang, to: 'ru').variants
            expect(v).to eq(variants)
          end
        end
      end
    end
  end
end
