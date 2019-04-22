# frozen_string_literal: true

class AddArticlesStatsToWords < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :articles_success, :integer, null: false, default: 0
    add_column :words, :articles_fail, :integer, null: false, default: 0
  end
end
