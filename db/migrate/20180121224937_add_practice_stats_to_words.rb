# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Rails/ReversibleMigration
class AddPracticeStatsToWords < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :practice_stats, :jsonb, default: {}, null: false
    Word.all.find_each do |w|
      w.update(practice_stats: {
                 wordsto_success: w.wordsto_success,
                 wordsto_fail: w.wordsto_fail,
                 wordsfrom_success: w.wordsfrom_success,
                 wordsfrom_fail: w.wordsfrom_fail,
                 articles_success: w.articles_success,
                 articles_fail: w.articles_fail
               })
    end
    add_index :words, :practice_stats, using: :gin
    remove_column :words, :wordsto_success # rubocop:disable Rails/BulkChangeTable
    remove_column :words, :wordsto_fail
    remove_column :words, :wordsfrom_success
    remove_column :words, :wordsfrom_fail
    remove_column :words, :articles_success
    remove_column :words, :articles_fail
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Rails/ReversibleMigration
