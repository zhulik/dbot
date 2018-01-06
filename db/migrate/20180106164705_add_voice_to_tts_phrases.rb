# frozen_string_literal: true

# rubocop:disable Rails/NotNullColumn
class AddVoiceToTtsPhrases < ActiveRecord::Migration[5.2]
  def change
    add_column :tts_phrases, :voice, :string, null: false
  end
end
# rubocop:enable Rails/NotNullColumn
