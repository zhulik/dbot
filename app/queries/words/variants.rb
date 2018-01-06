# frozen_string_literal: true

class Words::Variants
  def initialize(user, word)
    @user = user
    @word = word
  end

  def get
    variants = @user.current_words.where(pos: @word.pos)
                    .where.not(id: @word.id)
                    .order("difference(word, '#{@word.word}') DESC")
                    .limit(10).to_a.sample(4)
    variants << @word
    variants.shuffle
  end
end
