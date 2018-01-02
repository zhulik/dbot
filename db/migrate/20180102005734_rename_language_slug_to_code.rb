# frozen_string_literal: true

class RenameLanguageSlugToCode < ActiveRecord::Migration[5.1]
  def change
    rename_column :languages, :slug, :code
  end
end
