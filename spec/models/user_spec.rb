
RSpec.describe User, type: :model do
  # ── Associations ────────────────────────────────────────────────────────────
  it { is_expected.to have_many(:listings).dependent(:destroy) }
  it { is_expected.to have_many(:bookings).dependent(:destroy) }
  it { is_expected.to have_many(:reviews).dependent(:destroy) }
  it { is_expected.to have_many(:gateway_configs).dependent(:destroy) }
  it { is_expected.to have_many(:notifications).dependent(:destroy) }

  # ── Validations ─────────────────────────────────────────────────────────────
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_inclusion_of(:role).in_array(User::ROLES).allow_nil }

  # ── Role helpers ────────────────────────────────────────────────────────────
  describe "role predicates" do
    it "returns true for guest?" do
      expect(build(:user, role: "guest").guest?).to be true
    end

    it "returns true for host?" do
      expect(build(:user, :host).host?).to be true
    end

    it "returns true for admin?" do
      expect(build(:user, :admin).admin?).to be true
    end
  end

  # ── Default role ────────────────────────────────────────────────────────────
  describe "#set_default_role" do
    it "defaults role to guest when not provided" do
      user = create(:user, role: nil)
      expect(user.role).to eq("guest")
    end

    it "preserves an explicitly set role" do
      user = create(:user, :host)
      expect(user.role).to eq("host")
    end
  end

  # ── display_name ────────────────────────────────────────────────────────────
  describe "#display_name" do
    it "returns name when present" do
      user = build(:user, name: "Priya Sharma")
      expect(user.display_name).to eq("Priya Sharma")
    end

    it "falls back to email prefix when name is blank" do
      user = build(:user, name: "", email: "priya@example.com")
      expect(user.display_name).to eq("priya")
    end
  end

  # ── gateway_config_for ──────────────────────────────────────────────────────
  describe "#gateway_config_for" do
    let(:host) { create(:user, :host) }

    it "returns active config for the given gateway" do
      cfg = create(:gateway_config, user: host, gateway: "razorpay", active: true)
      expect(host.gateway_config_for("razorpay")).to eq(cfg)
    end

    it "returns nil when no config exists for the gateway" do
      expect(host.gateway_config_for("stripe")).to be_nil
    end

    it "returns nil when config exists but is inactive" do
      create(:gateway_config, user: host, gateway: "razorpay", active: false)
      expect(host.gateway_config_for("razorpay")).to be_nil
    end
  end
end
