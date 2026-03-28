
RSpec.describe Booking, type: :model do
  # ── Associations ────────────────────────────────────────────────────────────
  it { is_expected.to belong_to(:listing) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:review).dependent(:destroy) }
  it { is_expected.to have_one(:payment).dependent(:destroy) }

  # ── Validations ─────────────────────────────────────────────────────────────
  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }
  it { is_expected.to validate_presence_of(:total_price) }
  it { is_expected.to validate_numericality_of(:total_price).is_greater_than(0) }
  it { is_expected.to validate_inclusion_of(:status).in_array(Booking::STATUSES) }
  it { is_expected.to validate_inclusion_of(:payment_gateway).in_array(Booking::GATEWAYS).allow_nil }

  # ── Custom validations ──────────────────────────────────────────────────────
  describe "end_after_start" do
    it "is invalid when end_time is before start_time" do
      booking = build(:booking,
        start_time: 1.day.from_now.change(hour: 14),
        end_time:   1.day.from_now.change(hour: 10))
      expect(booking).not_to be_valid
      expect(booking.errors[:end_time]).to be_present
    end

    it "is valid when end_time is after start_time" do
      booking = build(:booking,
        start_time: 1.day.from_now.change(hour: 10),
        end_time:   1.day.from_now.change(hour: 12))
      expect(booking).to be_valid
    end
  end

  describe "no_overlap" do
    let(:listing) { create(:listing) }

    it "is invalid when overlapping a confirmed booking" do
      create(:booking, :confirmed,
        listing: listing,
        start_time: 2.days.from_now.change(hour: 10),
        end_time:   2.days.from_now.change(hour: 14))

      overlapping = build(:booking,
        listing: listing,
        start_time: 2.days.from_now.change(hour: 12),
        end_time:   2.days.from_now.change(hour: 16))

      expect(overlapping).not_to be_valid
      expect(overlapping.errors[:base]).to be_present
    end

    it "is valid when a cancelled booking exists in the same slot" do
      create(:booking, :cancelled,
        listing: listing,
        start_time: 2.days.from_now.change(hour: 10),
        end_time:   2.days.from_now.change(hour: 14))

      new_booking = build(:booking,
        listing: listing,
        start_time: 2.days.from_now.change(hour: 10),
        end_time:   2.days.from_now.change(hour: 14))

      expect(new_booking).to be_valid
    end
  end

  # ── Scopes ──────────────────────────────────────────────────────────────────
  describe ".upcoming" do
    it "returns pending/confirmed bookings in the future" do
      upcoming  = create(:booking, :confirmed, start_time: 3.days.from_now, end_time: 3.days.from_now + 2.hours)
      _past     = create(:booking, :completed, start_time: 3.days.ago,      end_time: 3.days.ago + 2.hours)
      _cancelled = create(:booking, :cancelled, start_time: 3.days.from_now, end_time: 3.days.from_now + 2.hours)

      expect(Booking.upcoming).to include(upcoming)
      expect(Booking.upcoming).not_to include(_past, _cancelled)
    end
  end

  # ── Instance methods ────────────────────────────────────────────────────────
  describe "#hours_duration" do
    it "calculates duration in hours" do
      booking = build(:booking,
        start_time: Time.current.change(hour: 9),
        end_time:   Time.current.change(hour: 12))
      expect(booking.hours_duration).to eq(3.0)
    end
  end

  describe "#reviewable?" do
    it "is true for a completed booking with no review" do
      booking = create(:booking, :completed)
      expect(booking.reviewable?).to be true
    end

    it "is false for a completed booking that already has a review" do
      booking = create(:booking, :completed)
      create(:review, booking: booking, listing: booking.listing, user: booking.user)
      expect(booking.reload.reviewable?).to be false
    end

    it "is false for a non-completed booking" do
      expect(build(:booking, :confirmed).reviewable?).to be false
    end
  end
end
