RSpec.describe BookingMailer, type: :mailer do
  let(:booking) { create(:booking, :confirmed) }

  describe "#booking_created" do
    let(:mail) { described_class.booking_created(booking) }

    it "renders the subject" do
      expect(mail.subject).to include(booking.listing.title)
    end

    it "sends to the guest" do
      expect(mail.to).to eq([ booking.user.email ])
    end

    it "includes the total price" do
      expect(mail.body.encoded).to include(booking.total_price.to_i.to_s)
    end
  end

  describe "#host_new_booking" do
    let(:mail) { described_class.host_new_booking(booking) }

    it "sends to the host" do
      expect(mail.to).to eq([ booking.listing.user.email ])
    end

    it "includes the guest name" do
      expect(mail.body.encoded).to include(booking.user.display_name)
    end
  end

  describe "#booking_confirmed" do
    let(:mail) { described_class.booking_confirmed(booking) }

    it "sends to the guest" do
      expect(mail.to).to eq([ booking.user.email ])
    end

    it "includes confirmed message" do
      expect(mail.subject).to include("confirmed")
    end
  end
end
