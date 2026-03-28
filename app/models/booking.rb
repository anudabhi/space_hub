class Booking < ApplicationRecord
  belongs_to :listing
  belongs_to :user
  has_one :review, dependent: :destroy
  has_one :payment, dependent: :destroy

  STATUSES = %w[pending confirmed completed cancelled].freeze
  GATEWAYS = %w[razorpay stripe].freeze

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :payment_gateway, inclusion: { in: GATEWAYS }, allow_nil: true
  validate :end_after_start
  validate :no_overlap

  scope :upcoming,   -> { where(status: %w[pending confirmed]).where("start_time > ?", Time.current) }
  scope :past,       -> { where(status: "completed") }
  scope :cancelled,  -> { where(status: "cancelled") }

  def hours_duration
    ((end_time - start_time) / 1.hour).round(1)
  end

  def reviewable?
    status == "completed" && review.nil?
  end

  private

  def end_after_start
    return unless start_time && end_time
    errors.add(:end_time, "must be after start time") if end_time <= start_time
  end

  def no_overlap
    return unless listing && start_time && end_time
    overlap = listing.bookings
                     .where.not(id: id)
                     .where.not(status: "cancelled")
                     .where("start_time < ? AND end_time > ?", end_time, start_time)
    errors.add(:base, "This time slot is already booked") if overlap.exists?
  end
end
