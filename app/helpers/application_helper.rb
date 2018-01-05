# frozen_string_literal: true

module ApplicationHelper
  def pagination_info(scope)
    t('common.pagination', page: scope.current_page, total_pages: scope.total_pages,
                           total_count: scope.total_count)
  end
end
