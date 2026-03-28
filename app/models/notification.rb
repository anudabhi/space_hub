class Notification < ApplicationRecord
  belongs_to :user

  KINDS = %w[booking_created booking_confirmed booking_completed booking_cancelled].freeze

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(15) }

  def self.notify(user:, message:, link: nil, kind: nil)
    create!(user: user, message: message, link: link, kind: kind)
  end
end
