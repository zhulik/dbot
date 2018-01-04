# frozen_string_literal: true

module UserAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      show do
        include_all_fields
        field :user_link do
          pretty_value { bindings[:view].link_to(bindings[:object].user_link, bindings[:object].user_link) }
        end
      end
    end
  end
end
