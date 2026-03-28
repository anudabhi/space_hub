RSpec.describe Notification, type: :model do
  # ── Associations ────────────────────────────────────────────────────────────
  it { is_expected.to belong_to(:user) }

  # ── Scopes ──────────────────────────────────────────────────────────────────
  describe ".unread" do
    it "returns only unread notifications" do
      user  = create(:user)
      unread = create(:notification, user: user, read: false)
      _read  = create(:notification, user: user, read: true)
      expect(Notification.unread).to contain_exactly(unread)
    end
  end

  describe ".recent" do
    it "returns notifications ordered by created_at desc, limited to 15" do
      user = create(:user)
      create_list(:notification, 16, user: user)
      expect(Notification.recent.count).to eq(15)
      expect(Notification.recent.first.created_at).to be >= Notification.recent.last.created_at
    end
  end

  # ── .notify ─────────────────────────────────────────────────────────────────
  describe ".notify" do
    it "creates a notification for the given user" do
      user = create(:user)
      expect {
        Notification.notify(user: user, message: "Test", kind: "booking_created")
      }.to change(Notification, :count).by(1)
    end

    it "sets message, kind, and link correctly" do
      user  = create(:user)
      notif = Notification.notify(user: user, message: "Hello", kind: "booking_confirmed", link: "/bookings/1")
      expect(notif.message).to eq("Hello")
      expect(notif.kind).to eq("booking_confirmed")
      expect(notif.link).to eq("/bookings/1")
    end

    it "defaults read to false" do
      user  = create(:user)
      notif = Notification.notify(user: user, message: "Hello", kind: "booking_created")
      expect(notif.read).to be false
    end
  end
end
