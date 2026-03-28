class AddAcceptedGatewaysToListings < ActiveRecord::Migration[8.0]
  def change
    add_column :listings, :accepted_gateways, :string, array: true, default: %w[razorpay stripe]
  end
end
