RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }

  describe "GET /notifications" do
    context "when not signed in" do
      it "redirects to sign in" do
        get notifications_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in user }

      it "returns 200" do
        get notifications_path
        expect(response).to have_http_status(:ok)
      end

      it "shows only own notifications" do
        own   = create(:notification, user: user, message: "Your booking confirmed")
        other = create(:notification, message: "Someone else")
        get notifications_path
        expect(response.body).to include("Your booking confirmed")
        expect(response.body).not_to include("Someone else")
      end
    end
  end

  describe "PATCH /notifications/:id/mark_read" do
    before { sign_in user }

    it "marks notification as read and redirects to its link" do
      notif = create(:notification, user: user, read: false, link: "/guest/bookings/1")
      patch mark_read_notification_path(notif)
      expect(notif.reload.read).to be true
      expect(response).to redirect_to("/guest/bookings/1")
    end

    it "cannot mark another user's notification as read" do
      other_notif = create(:notification, read: false)
      patch mark_read_notification_path(other_notif)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /notifications/mark_all_read" do
    before { sign_in user }

    it "marks all unread notifications as read" do
      create_list(:notification, 3, user: user, read: false)
      patch mark_all_read_notifications_path
      expect(user.notifications.unread.count).to eq(0)
    end

    it "redirects to notifications page" do
      patch mark_all_read_notifications_path
      expect(response).to redirect_to(notifications_path)
    end
  end
end
