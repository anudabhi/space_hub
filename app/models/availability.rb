class Availability < ApplicationRecord
  belongs_to :listing

  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_after_start

  scope :available, -> { where(is_available: true) }
  scope :for_date,  ->(date) { where(date: date) }

  private

  def end_after_start
    return unless start_time && end_time
    errors.add(:end_time, "must be after start time") if end_time <= start_time
  end
end
