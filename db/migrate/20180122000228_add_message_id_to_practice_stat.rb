# frozen_string_literal: true

class AddMessageIdToPracticeStat < ActiveRecord::Migration[5.1]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :practice_stats, :message_id, :bigint, null: false # rubocop:disable Rails/BulkChangeTable
    add_column :practice_stats, :chat_id, :bigint, null: false
    add_index :practice_stats, %i[message_id chat_id], unique: true
    # rubocop:enable Rails/NotNullColumn
  end
end
