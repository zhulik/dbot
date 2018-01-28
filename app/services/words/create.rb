# frozen_string_literal: true

class Words::Create < Opie::Operation
  step :create!

  def create!(user, params)
    user.current_words.create!(params)
  rescue ActiveRecord::RecordInvalid => e
    fail(:invalid_record, e.record.errors.full_messages.join("\n"))
  end
end
