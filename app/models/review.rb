class Review < ApplicationRecord
  belongs_to :booking
  belongs_to :listing
  belongs_to :user

  validates :rating, presence: true, numericality: { only_integer: true, in: 1..5 }
  validates :body, presence: true, length: { minimum: 10 }
  validates :booking_id, uniqueness: true

  after_create  :update_listing_rating
  after_destroy :update_listing_rating

  private

  def update_listing_rating
    listing.update_rating!
  end
end
