require "cancan/matchers"

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  let(:host)    { create(:user, :host) }
  let(:guest)   { create(:user) }
  let(:admin)   { create(:user, :admin) }

  let(:host_listing)  { create(:listing, user: host) }
  let(:other_listing) { create(:listing) }

  # ── Guest (not signed in) ────────────────────────────────────────────────
  context "when user is nil (not signed in)" do
    let(:user) { nil }

    it { is_expected.to be_able_to(:read, create(:listing, status: "active")) }
    it { is_expected.not_to be_able_to(:read, create(:listing, :draft)) }
    it { is_expected.not_to be_able_to(:create, Booking.new) }
    it { is_expected.not_to be_able_to(:create, Listing.new) }
  end

  # ── Guest (signed in) ────────────────────────────────────────────────────
  context "when user is a guest" do
    let(:user) { guest }

    it { is_expected.to be_able_to(:read, create(:listing, status: "active")) }
    it { is_expected.to be_able_to(:create, Booking.new) }
    it { is_expected.not_to be_able_to(:manage, Listing.new) }

    it "can read own bookings" do
      own_booking = create(:booking, user: guest)
      is_expected.to be_able_to(:read, own_booking)
    end

    it "cannot read another user's booking" do
      other_booking = create(:booking)
      is_expected.not_to be_able_to(:read, other_booking)
    end

    it "can cancel own booking" do
      own_booking = create(:booking, user: guest)
      is_expected.to be_able_to(:cancel, own_booking)
    end
  end

  # ── Host ─────────────────────────────────────────────────────────────────
  context "when user is a host" do
    let(:user) { host }

    it { is_expected.to be_able_to(:manage, host_listing) }
    it { is_expected.not_to be_able_to(:update, other_listing) }
    it { is_expected.not_to be_able_to(:destroy, other_listing) }

    it "can read bookings on own listings" do
      booking = create(:booking, listing: host_listing)
      is_expected.to be_able_to(:read, booking)
    end

    it "can confirm bookings on own listings" do
      booking = create(:booking, listing: host_listing)
      is_expected.to be_able_to(:confirm, booking)
    end

    it "cannot confirm bookings on other listings" do
      booking = create(:booking, listing: other_listing)
      is_expected.not_to be_able_to(:confirm, booking)
    end

    it "can manage availabilities on own listings" do
      availability = create(:availability, listing: host_listing)
      is_expected.to be_able_to(:manage, availability)
    end
  end

  # ── Admin ─────────────────────────────────────────────────────────────────
  context "when user is an admin" do
    let(:user) { admin }

    it { is_expected.to be_able_to(:manage, :all) }
    it { is_expected.to be_able_to(:destroy, other_listing) }
    it { is_expected.to be_able_to(:manage, create(:booking)) }
  end
end
