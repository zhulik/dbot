# frozen_string_literal: true

class AddWordstoStatsToWords < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :wordsto_success, :integer, null: false, default: 0 # rubocop:disable Rails/BulkChangeTable
    add_column :words, :wordsto_fail, :integer, null: false, default: 0
  end
end
