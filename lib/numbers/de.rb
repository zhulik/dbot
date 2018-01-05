# frozen_string_literal: true

class Numbers::De
  DIGITS = {
    '0' => 'null',
    '1' => 'ein',
    '2' => 'zwei',
    '3' => 'drei',
    '4' => 'vier',
    '5' => 'fünf',
    '6' => 'sechs',
    '7' => 'sieben',
    '8' => 'acht',
    '9' => 'neun',
    '10' => 'zehn',
    '11' => 'elf',
    '12' => 'zwölf',
    '13' => 'dreizehn',
    '14' => 'vierzehn',
    '15' => 'fünfzehn',
    '16' => 'sechzehn',
    '17' => 'siebzehn',
    '18' => 'achtzehn',
    '19' => 'neunzehn',
    '20' => 'zwanzig',
    '30' => 'dreißig',
    '40' =>	'vierzig',
    '50' =>	'fünfzig',
    '60' =>	'sechzig',
    '70' =>	'siebzig',
    '80' =>	'achtzig',
    '90' =>	'neunzig',
    '100' => 'hundert',
    '1000' =>	'tausend'
  }.freeze

  class << self
    delegate :words, to: :new
  end

  def words(number)
    raise ArgumentError if number > 999_999
    result = if DIGITS[number.to_s].present?
               DIGITS[number.to_s]
             else
               thousands, number = number.to_s.split('').reverse.each_slice(3).to_a.map do |part|
                 part.join.reverse.to_i
               end.reverse

               r = under_thousand(thousands)
               r = r + DIGITS['1000'] + under_thousand(number) if number.present?
               r
             end

    result += 's' if result.ends_with?('ein')
    result
  end

  private

  # rubocop:disable Metrics/MethodLength
  def under_thousand(number)
    digits = number.to_s.split('').reverse.map(&:to_i)
    multiplier = 100
    enum = digits.to_enum
    index = -1
    result = ''
    loop do
      digit = enum.next
      index += 1
      if index.zero?
        result = under_hundred(digits)
        enum.next
        next
      end
      result = DIGITS[digit.to_s] + DIGITS[multiplier.to_s] + result
      multiplier *= 10
    end
    result
  end
  # rubocop:enable Metrics/MethodLength

  def under_hundred(digits)
    return '' if digits[0].zero? && digits.one?
    n = DIGITS["#{digits[1]}#{digits[0]}".to_i.to_s]
    return '' if n == 'null'
    return n if n.present?
    DIGITS[digits[0].to_s] + 'und' + DIGITS[(digits[1] * 10).to_s]
  end
end
