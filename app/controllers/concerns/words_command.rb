# frozen_string_literal: true

module WordsCommand
  extend ActiveSupport::Concern

  def words_callback_query(query)
    query, page = query.split(':')
    return unless query == 'page'
    scope = current_user.current_words.order(:word).page(page)
    ws = scope.map { |w| "#{w.word} - #{w.translation} #{w.pos} #{w.gen}" }.join("\n")
    respond_message text: "#{t('common.your_saved_words')}\n#{ws}\n#{pagination_info(scope)}",
                    reply_markup: { inline_keyboard: pagination_keyboard(scope, 'words') }
  end

  def words(*)
    scope = current_user.current_words.order(:word).page(1)
    return respond_message text: t('.no_words_added') if scope.empty?
    ws = scope.map { |w| "#{w.word} - #{w.translation} #{w.pos} #{w.gen}" }.join("\n")
    respond_message text: "#{t('common.your_saved_words')}\n#{ws}\n#{pagination_info(scope)}",
                    reply_markup: { inline_keyboard: pagination_keyboard(scope, 'words') }
  end
end
