# frozen_string_literal: true

class Numbers::De
  DIGITS = YAML.load_file('lib/numbers/de.yml')['de']

  class << self
    delegate :words, to: :new
  end

  def words(number)
    raise ArgumentError if number > 999_999_999_999 || number.negative?
    return postprocess(DIGITS[number]) if DIGITS[number].present?

    number = number.to_s.rjust(12, '0')

    billions, millions, thousands, number = number.to_s.reverse.scan(/.{1,3}/).map do |part|
      part.reverse.to_i
    end.reverse

    postprocess(process(billions, millions, thousands, number))
  end

  private

  def process(billions, millions, thousands, number)
    result = under_thousand(number)
    result = "#{under_thousand(thousands)}#{DIGITS[1000]}#{result}" unless thousands.zero?
    unless millions.zero?
      n = under_thousand(millions)
      result = "#{n == 'ein' ? 'eine' : n} #{decline(millions, DIGITS[1_000_000])} #{result}"
    end
    unless billions.zero?
      n = under_thousand(billions)
      result = "#{n == 'ein' ? 'eine' : n} #{decline(billions, DIGITS[1_000_000_000])} #{result}"
    end
    result
  end

  def postprocess(result)
    result += 's' if result.ends_with?('ein')
    result = 'ein' + result if %w(hundert tausend).include?(result)
    result = 'eine ' + result if %w(Million Milliarde).include?(result)
    result.strip
  end

  def under_thousand(number)
    digits = number.to_s.split('').reverse.map(&:to_i)
    result = under_hundred(digits.first(2))
    result = DIGITS[digits.last] + DIGITS[100] + result if digits.count > 2
    result
  end

  def under_hundred(digits)
    return '' if digits.all?(&:zero?)
    n = DIGITS["#{digits[1]}#{digits[0]}".to_i]
    return n if n.present?
    DIGITS[digits[0]] + 'und' + DIGITS[(digits[1] * 10)]
  end

  def decline(count, number)
    return number if count == 1
    return number + 'n' if number.ends_with?('e')
    number + 'en'
  end
end
