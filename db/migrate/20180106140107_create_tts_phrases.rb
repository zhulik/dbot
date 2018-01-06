# frozen_string_literal: true

class CreateTtsPhrases < ActiveRecord::Migration[5.2]
  def change
    create_table :tts_phrases do |t|
      t.string :phrase, null: false
      t.references :language, foreign_key: true, null: false

      t.timestamps
    end
    add_index :tts_phrases, %i[phrase language_id], unique: true
  end
end
