# frozen_string_literal: true

class WordsCommand < Command
  usage -> { I18n.t('dbot.words.usage') }
  help -> { I18n.t('dbot.words.help') }
  arguments 0

  def message_0
    respond_page
  end

  def callback_query(query)
    query, page = query.split(':')
    return unless query == 'page'

    respond_page(page)
  end

  private

  def pagination_keyboard(scope, ctx)
    InlineKeyboard.render do |k|
      k.columns 2
      k.button t('common.prev_page'), ctx, :page, scope.prev_page unless scope.first_page?
      k.button t('common.next_page'), ctx, :page, scope.next_page unless scope.last_page?
    end
  end

  def pagination_info(scope)
    t('common.pagination', page: scope.current_page, total_pages: scope.total_pages,
                           total_count: scope.total_count)
  end

  def respond_page(page = 1)
    scope = current_user.current_words.order(:word).page(page)
    raise NoWordsAddedError if scope.empty? && page == 1

    ws = scope.map do |w|
      "#{w.id} #{full_description(w)}"
    end.join("\n")
    respond_message text: "#{t('common.your_saved_words')}\n#{ws}\n#{pagination_info(scope)}",
                    reply_markup: { inline_keyboard: pagination_keyboard(scope, 'words') }
  end
end
