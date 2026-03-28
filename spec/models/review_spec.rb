
RSpec.describe Review, type: :model do
  subject { build(:review) }

  # ── Associations ────────────────────────────────────────────────────────────
  it { is_expected.to belong_to(:booking) }
  it { is_expected.to belong_to(:listing) }
  it { is_expected.to belong_to(:user) }

  # ── Validations ─────────────────────────────────────────────────────────────
  it { is_expected.to validate_presence_of(:rating) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_numericality_of(:rating).only_integer.is_in(1..5) }
  it { is_expected.to validate_length_of(:body).is_at_least(10) }
  it { is_expected.to validate_uniqueness_of(:booking_id) }

  # ── Callbacks ───────────────────────────────────────────────────────────────
  describe "after_create" do
    it "updates the listing rating after a review is created" do
      listing = create(:listing, avg_rating: nil, reviews_count: 0)
      user    = create(:user)
      booking = create(:booking, :completed, listing: listing, user: user)

      expect {
        create(:review, booking: booking, listing: listing, user: user, rating: 5)
      }.to change { listing.reload.avg_rating }.to(5.0)
        .and change { listing.reload.reviews_count }.to(1)
    end
  end

  describe "after_destroy" do
    it "updates the listing rating after a review is destroyed" do
      listing = create(:listing)
      user    = create(:user)
      booking = create(:booking, :completed, listing: listing, user: user)
      review  = create(:review, booking: booking, listing: listing, user: user, rating: 4)

      expect { review.destroy }.to change { listing.reload.reviews_count }.from(1).to(0)
    end
  end
end
