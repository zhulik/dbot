# frozen_string_literal: true

module ApplicationHelper
  def pagination_info(scope)
    t('common.pagination', page: scope.current_page, total_pages: scope.total_pages,
                           total_count: scope.total_count)
  end

  def respond_message(**args)
    case payload
    when Telegram::Bot::Types::CallbackQuery
      edit_message :text, **args
    when Telegram::Bot::Types::Message
      respond_with :message, **args
    end
  end
end
