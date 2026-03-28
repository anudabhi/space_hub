class HostApplicationController < UserApplicationController
  before_action :require_host!
end
