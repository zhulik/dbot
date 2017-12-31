# frozen_string_literal: true

class CreateLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table :languages do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end
    add_index :languages, :slug, unique: true
  end
end
