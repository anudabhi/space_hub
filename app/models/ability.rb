class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest (not signed in)

    # ── Everyone (including guests) ──────────────────────────────────────────
    can :read, Listing, status: "active"
    can :read, Review

    # ── Signed-in guests ─────────────────────────────────────────────────────
    if user.persisted?
      # Own bookings
      can :create, Booking
      can %i[read cancel], Booking, user_id: user.id

      # Reviews — only on own completed bookings, one per booking
      can :create, Review

      # Own profile
      can %i[update destroy], User, id: user.id
    end

    # ── Hosts ─────────────────────────────────────────────────────────────────
    if user.host? || user.admin?
      # Own listings (full CRUD)
      can :manage, Listing, user_id: user.id

      # Availabilities for own listings
      can :manage, Availability do |availability|
        availability.listing&.user_id == user.id
      end

      # Bookings on own listings (read + status changes)
      can %i[read confirm complete], Booking do |booking|
        booking.listing&.user_id == user.id
      end
    end

    # ── Admins ────────────────────────────────────────────────────────────────
    if user.admin?
      can :manage, :all
    end
  end
end
