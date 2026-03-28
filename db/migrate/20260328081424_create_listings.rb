class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :category
      t.string :city
      t.string :address
      t.decimal :price_per_hour
      t.integer :capacity
      t.text :amenities
      t.text :photos_data
      t.string :status
      t.decimal :avg_rating
      t.integer :reviews_count

      t.timestamps
    end
  end
end
