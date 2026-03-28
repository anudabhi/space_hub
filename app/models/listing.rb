class Listing < ApplicationRecord
  belongs_to :user
  has_many :availabilities, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :photos

  CATEGORIES = %w[wellness creative events].freeze
  CITIES = %w[Mumbai Delhi Bangalore Chennai Hyderabad Pune].freeze
  STATUSES = %w[draft active inactive].freeze
  GATEWAYS  = %w[razorpay stripe].freeze

  validates :title, presence: true
  validates :description, presence: true
  validates :category, inclusion: { in: CATEGORIES }
  validates :city, inclusion: { in: CITIES }
  validates :price_per_hour, presence: true, numericality: { greater_than: 0 }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }
  validate :accepted_gateways_valid

  def accepted_gateways_list
    (accepted_gateways || []) & GATEWAYS
  end

  scope :active,    -> { where(status: "active") }
  scope :by_city,   ->(city) { where(city: city) if city.present? }
  scope :by_category, ->(cat) { where(category: cat) if cat.present? }

  def self.ransackable_attributes(_auth_object = nil)
    # Explicitly allowlist only guest-facing search fields.
    # Intentionally excluded: id, user_id, status, avg_rating, reviews_count,
    #   photos_data, created_at, updated_at (not useful/safe for public search).
    %w[title description category city address price_per_hour capacity amenities]
  end

  def self.ransackable_associations(_auth_object = nil)
    # No association-based search exposed publicly.
    []
  end

  def update_rating!
    update_columns(
      avg_rating: reviews.any? ? reviews.average(:rating).to_f.round(1) : nil,
      reviews_count: reviews.count
    )
  end

  private

  def accepted_gateways_valid
    return if (accepted_gateways || []).all? { |g| GATEWAYS.include?(g) }
    errors.add(:accepted_gateways, "contains an invalid gateway")
  end

  public

  def cover_photo
    photos.first
  end
end
