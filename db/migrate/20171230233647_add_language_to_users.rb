# frozen_string_literal: true

class AddLanguageToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :language_id, :integer
    add_foreign_key :users, :languages, on_delete: :nullify
  end
end
