# frozen_string_literal: true

module ApplicationHelper
  def pagination_info(scope)
    t('common.pagination', page: scope.current_page, total_pages: scope.total_pages,
                           total_count: scope.total_count)
  end

  def respond_message(**params)
    case payload
    when Telegram::Bot::Types::CallbackQuery
      edit_message :text, **params
    when Telegram::Bot::Types::Message
      respond_with :message, **params
    end
  end
end
