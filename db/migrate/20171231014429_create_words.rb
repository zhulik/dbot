# frozen_string_literal: true

class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.references :user
      t.references :language
      t.string :word, null: false
      t.string :translation, null: false

      t.timestamps
    end

    add_index :words, %i[user_id language_id word], unique: true

    add_foreign_key :words, :languages, on_delete: :cascade
    add_foreign_key :words, :users, on_delete: :cascade
  end
end
