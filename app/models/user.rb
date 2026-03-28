class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[guest host admin].freeze

  has_many :listings,        foreign_key: :user_id, dependent: :destroy
  has_many :bookings,        foreign_key: :user_id, dependent: :destroy
  has_many :reviews,         foreign_key: :user_id, dependent: :destroy
  has_many :gateway_configs,  foreign_key: :user_id, dependent: :destroy
  has_many :notifications,    foreign_key: :user_id, dependent: :destroy

  def gateway_config_for(gateway)
    gateway_configs.active.find_by(gateway: gateway)
  end

  has_one_attached :avatar

  validates :name, presence: true
  validates :role, inclusion: { in: ROLES }, allow_nil: true

  before_create :set_default_role

  def guest?  = role == "guest"
  def host?   = role == "host"
  def admin?  = role == "admin"

  def display_name
    name.presence || email.split("@").first
  end

  private

  def set_default_role
    self.role ||= "guest"
  end
end
