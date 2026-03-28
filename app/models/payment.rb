class Payment < ApplicationRecord
  belongs_to :booking

  GATEWAYS = %w[razorpay stripe].freeze
  STATUSES = %w[pending captured failed refunded].freeze

  validates :gateway, inclusion: { in: GATEWAYS }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }

  def captured? = status == "captured"
  def failed?   = status == "failed"
end
