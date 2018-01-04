# frozen_string_literal: true

module WordsCommand
  def words(*)
    # TODO: add pagination
    words = current_user.current_words.order(:word)
    return respond_with :message, text: t('.no_words_added') if words.empty?
    words = words.map { |w| "#{w.word} - #{w.translation} #{w.pos} #{w.gen}" }.join("\n")
    respond_with :message, text: "#{t('.your_saved_words')}\n#{words}"
  end
end
