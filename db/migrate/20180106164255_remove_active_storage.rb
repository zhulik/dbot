# frozen_string_literal: true

# rubocop:disable Rails/ReversibleMigration
class RemoveActiveStorage < ActiveRecord::Migration[5.1]
  def change
    drop_table :active_storage_blobs
    drop_table :active_storage_attachments
  end
end
# rubocop:enable Rails/ReversibleMigration
