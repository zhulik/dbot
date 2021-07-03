# frozen_string_literal: true

class ChangeUniqueWordConstraint < ActiveRecord::Migration[5.1]
  def change
    remove_index :words, name: 'index_words_on_user_id_and_language_id_and_word' # rubocop:disable Rails/ReversibleMigration
    add_index :words, %w(user_id language_id word translation), unique: true
  end
end
