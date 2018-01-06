# frozen_string_literal: true

module WordAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :id
        field :user
        field :language
        field :word
        field :translation
        field :pos
        field :gen
        field :wordsfrom_success
        field :wordsfrom_fail
      end
    end
  end
end
