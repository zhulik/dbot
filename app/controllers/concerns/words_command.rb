# frozen_string_literal: true

module WordsCommand
  def words(*)
    # TODO: add pagination
    words = current_user.current_words.select(:word, :translation).order(:word)
    return respond_with :message, text: t('.no_words_added') if words.empty?
    msg = words.map { |w| "#{w.word} - #{w.translation}" }.join("\n")
    respond_with :message, text: "#{t('.your_saved_words')}\n#{msg}"
  end
end
