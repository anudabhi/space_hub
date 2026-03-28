class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.decimal :hours
      t.decimal :total_price
      t.string :status
      t.string :payment_gateway
      t.string :payment_id
      t.string :payment_order_id

      t.timestamps
    end
  end
end
