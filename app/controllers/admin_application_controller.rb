class AdminApplicationController < UserApplicationController
  before_action :require_admin!
end
