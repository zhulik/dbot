# frozen_string_literal: true

class AddWordsfromStatsToWords < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :wordsfrom_success, :integer, null: false, default: 0 # rubocop:disable Rails/BulkChangeTable
    add_column :words, :wordsfrom_fail, :integer, null: false, default: 0
  end
end
