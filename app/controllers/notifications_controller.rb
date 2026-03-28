class NotificationsController < UserApplicationController
  def index
    @notifications = current_user.notifications.recent
  end

  def mark_read
    notification = current_user.notifications.find(params[:id])
    notification.update!(read: true)
    redirect_to notification.link.presence || notifications_path
  end

  def mark_all_read
    current_user.notifications.unread.update_all(read: true)
    redirect_to notifications_path
  end
end
