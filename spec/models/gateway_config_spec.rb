RSpec.describe GatewayConfig, type: :model do
  subject { build(:gateway_config) }

  # ── Associations ────────────────────────────────────────────────────────────
  it { is_expected.to belong_to(:user) }

  # ── Validations ─────────────────────────────────────────────────────────────
  it { is_expected.to validate_presence_of(:key_id) }
  it { is_expected.to validate_presence_of(:key_secret) }
  it { is_expected.to validate_inclusion_of(:gateway).in_array(GatewayConfig::GATEWAYS) }
  it { is_expected.to validate_uniqueness_of(:gateway).scoped_to(:user_id) }

  # ── Scopes ──────────────────────────────────────────────────────────────────
  describe ".active" do
    it "returns only active configs" do
      active   = create(:gateway_config, active: true)
      _inactive = create(:gateway_config, :inactive, user: create(:user, :host))

      expect(GatewayConfig.active).to contain_exactly(active)
    end
  end

  # ── Predicates ──────────────────────────────────────────────────────────────
  describe "#razorpay?" do
    it "returns true for razorpay gateway" do
      expect(build(:gateway_config, gateway: "razorpay").razorpay?).to be true
    end

    it "returns false for stripe gateway" do
      expect(build(:gateway_config, :stripe).razorpay?).to be false
    end
  end

  describe "#stripe?" do
    it "returns true for stripe gateway" do
      expect(build(:gateway_config, :stripe).stripe?).to be true
    end

    it "returns false for razorpay gateway" do
      expect(build(:gateway_config, gateway: "razorpay").stripe?).to be false
    end
  end
end
