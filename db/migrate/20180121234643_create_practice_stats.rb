# frozen_string_literal: true

class CreatePracticeStats < ActiveRecord::Migration[5.1]
  def change
    create_table :practice_stats do |t|
      t.references :user, foreign_key: true
      t.string :practice, null: false
      t.string :status, null: false, default: 'in_progress'
      t.jsonb :stats, null: false, default: {}

      t.timestamps
    end
    add_index :practice_stats, :stats, using: :gin
  end
end
