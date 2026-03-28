class GatewayConfig < ApplicationRecord
  belongs_to :user

  GATEWAYS = %w[razorpay stripe].freeze

  scope :active, -> { where(active: true) }

  validates :gateway, inclusion: { in: GATEWAYS }
  validates :gateway, uniqueness: { scope: :user_id }
  validates :key_id,     presence: true
  validates :key_secret, presence: true

  def razorpay? = gateway == "razorpay"
  def stripe?   = gateway == "stripe"
end
