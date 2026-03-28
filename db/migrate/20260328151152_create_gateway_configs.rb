class CreateGatewayConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :gateway_configs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :gateway
      t.string :key_id
      t.string :key_secret
      t.boolean :active

      t.timestamps
    end
  end
end
