class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :gateway
      t.string :order_id
      t.string :payment_id
      t.decimal :amount
      t.string :currency
      t.string :status
      t.text :raw_response

      t.timestamps
    end
  end
end
