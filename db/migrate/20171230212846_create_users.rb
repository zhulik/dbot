# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.bigint :user_id, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
