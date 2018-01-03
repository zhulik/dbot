# frozen_string_literal: true

# rubocop:disable Rails/NotNullColumn
class AddFieldsToWords < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :pos, :string, null: false
    add_column :words, :gen, :string, null: false
  end
end
# rubocop:enable Rails/NotNullColumn
