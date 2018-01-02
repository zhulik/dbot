# frozen_string_literal: true

class Iso6391Validator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if LanguageList::LanguageInfo.find(value).present?
    record.errors[attribute] << "is invalid: #{value}"
  end
end
