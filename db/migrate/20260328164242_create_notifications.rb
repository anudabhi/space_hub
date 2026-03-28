class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message
      t.string :link
      t.boolean :read, default: false, null: false
      t.string :kind

      t.timestamps
    end
  end
end
