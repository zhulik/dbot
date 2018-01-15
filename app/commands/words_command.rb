# frozen_string_literal: true

class WordsCommand < Command
  usage -> { I18n.t('dbot.words.usage') }
  help -> { I18n.t('dbot.words.help') }
  arguments 0

  def message(*args)
    return respond_message text: self.class.usage if args.any?
    scope = current_user.current_words.order(:word).page(1)
    return respond_message text: t('dbot.words.no_words_added') if scope.empty?
    ws = scope.map { |w| "#{w.word} - #{w.translation} #{w.pos} #{w.gen}" }.join("\n")
    respond_message text: "#{t('common.your_saved_words')}\n#{ws}\n#{pagination_info(scope)}",
                    reply_markup: { inline_keyboard: pagination_keyboard(scope, 'words') }
  end

  def callback_query(query)
    query, page = query.split(':')
    return unless query == 'page'
    scope = current_user.current_words.order(:word).page(page)
    ws = scope.map { |w| "#{w.word} - #{w.translation} #{w.pos} #{w.gen}" }.join("\n")
    respond_message text: "#{t('common.your_saved_words')}\n#{ws}\n#{pagination_info(scope)}",
                    reply_markup: { inline_keyboard: pagination_keyboard(scope, 'words') }
  end

  private

  def pagination_keyboard(scope, ctx)
    [].tap do |keys|
      keys << { text: t('common.prev_page'), callback_data: "#{ctx}:page:#{scope.prev_page}" } unless scope.first_page?
      keys << { text: t('common.next_page'), callback_data: "#{ctx}:page:#{scope.next_page}" } unless scope.last_page?
    end.each_slice(2).to_a
  end
end
