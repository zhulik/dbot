# frozen_string_literal: true

class Words::Variants
  def initialize(user, word)
    @user = user
    @word = word
  end

  def get
    variants = @user.current_words.where(pos: @word.pos).where.not(id: @word.id).limit(4).to_a
    variants << @word
    variants.shuffle
  end
end
