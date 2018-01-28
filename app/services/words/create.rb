# frozen_string_literal: true

class Words::Create < Opie::Operation
  step :validate_pos
  step :validate_gen
  step :validate_presence
  step :create!

  def validate_pos(*args)
    user, params = args
    fail(:unknown_pos, params) unless Word.pos.keys.include?(params[:pos])
    [user, params]
  end

  def validate_gen(user, params)
    fail(:unknown_gen, params) if params[:gen].present? && !Word.gens.keys.include?(params[:gen])
    [user, params]
  end

  def validate_presence(user, params)
    fail(:already_added, params) if user.word?(params[:word])
    [user, params]
  end

  def create!(user, params)
    word = user.current_words.create!(params)
    word
  end
end
