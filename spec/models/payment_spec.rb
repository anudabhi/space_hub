
RSpec.describe Payment, type: :model do
  it { is_expected.to belong_to(:booking) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  it { is_expected.to validate_inclusion_of(:gateway).in_array(Payment::GATEWAYS) }
  it { is_expected.to validate_inclusion_of(:status).in_array(Payment::STATUSES) }

  describe "#captured?" do
    it "returns true when status is captured" do
      expect(build(:payment, status: "captured").captured?).to be true
    end

    it "returns false when status is failed" do
      expect(build(:payment, :failed).captured?).to be false
    end
  end

  describe "#failed?" do
    it "returns true when status is failed" do
      expect(build(:payment, :failed).failed?).to be true
    end
  end
end
