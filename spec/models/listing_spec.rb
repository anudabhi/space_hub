
RSpec.describe Listing, type: :model do
  # ── Associations ────────────────────────────────────────────────────────────
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:availabilities).dependent(:destroy) }
  it { is_expected.to have_many(:bookings).dependent(:destroy) }
  it { is_expected.to have_many(:reviews).dependent(:destroy) }

  # ── Validations ─────────────────────────────────────────────────────────────
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:price_per_hour) }
  it { is_expected.to validate_presence_of(:capacity) }
  it { is_expected.to validate_numericality_of(:price_per_hour).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:capacity).is_greater_than(0) }
  it { is_expected.to validate_inclusion_of(:category).in_array(Listing::CATEGORIES) }
  it { is_expected.to validate_inclusion_of(:city).in_array(Listing::CITIES) }
  it { is_expected.to validate_inclusion_of(:status).in_array(Listing::STATUSES) }

  # ── Scopes ──────────────────────────────────────────────────────────────────
  describe ".active" do
    it "returns only active listings" do
      active   = create(:listing, status: "active")
      _draft   = create(:listing, :draft)
      _inactive = create(:listing, :inactive)

      expect(Listing.active).to contain_exactly(active)
    end
  end

  describe ".by_city" do
    it "filters by city when value is present" do
      mumbai    = create(:listing, city: "Mumbai")
      _delhi    = create(:listing, city: "Delhi")

      expect(Listing.by_city("Mumbai")).to contain_exactly(mumbai)
    end

    it "returns all when city is blank" do
      create_list(:listing, 2)
      expect(Listing.by_city("").count).to eq(2)
    end
  end

  describe ".by_category" do
    it "filters by category" do
      wellness = create(:listing, :wellness)
      _events  = create(:listing, :events)

      expect(Listing.by_category("wellness")).to contain_exactly(wellness)
    end
  end

  # ── ransackable_attributes ──────────────────────────────────────────────────
  describe ".ransackable_attributes" do
    let(:allowed) { %w[title description category city address price_per_hour capacity amenities] }

    it "only exposes safe search fields" do
      expect(Listing.ransackable_attributes).to match_array(allowed)
    end

    it "does not expose user_id" do
      expect(Listing.ransackable_attributes).not_to include("user_id")
    end

    it "does not expose status" do
      expect(Listing.ransackable_attributes).not_to include("status")
    end
  end

  # ── accepted_gateways_list ──────────────────────────────────────────────────
  describe "#accepted_gateways_list" do
    it "returns intersection of stored gateways and valid GATEWAYS" do
      listing = build(:listing, accepted_gateways: ["razorpay", "stripe"])
      expect(listing.accepted_gateways_list).to contain_exactly("razorpay", "stripe")
    end

    it "filters out invalid gateway values" do
      listing = build(:listing, accepted_gateways: ["razorpay", "paypal"])
      expect(listing.accepted_gateways_list).to contain_exactly("razorpay")
    end

    it "returns empty array when accepted_gateways is nil" do
      listing = build(:listing, accepted_gateways: nil)
      expect(listing.accepted_gateways_list).to eq([])
    end
  end

  # ── update_rating! ──────────────────────────────────────────────────────────
  describe "#update_rating!" do
    it "recalculates avg_rating and reviews_count from reviews" do
      listing = create(:listing)
      user    = create(:user)

      2.times do |i|
        booking = create(:booking, :completed, listing: listing, user: user)
        create(:review, booking: booking, listing: listing, user: user, rating: i == 0 ? 4 : 5)
      end

      listing.reload
      expect(listing.avg_rating).to eq(4.5)
      expect(listing.reviews_count).to eq(2)
    end

    it "does nothing when there are no reviews" do
      listing = create(:listing, avg_rating: nil, reviews_count: 0)
      expect { listing.update_rating! }.not_to change { listing.reload.avg_rating }
    end
  end
end
