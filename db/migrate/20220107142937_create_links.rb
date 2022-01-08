# frozen_string_literal: true

class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.references :user, foreign_key: true
      t.string :url
      t.string :slug, null: false
      t.datetime :expires_at
      t.timestamps
    end

    add_index :links, :slug, unique: true
  end
end
