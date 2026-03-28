class UserApplicationController < ApplicationController
  before_action :authenticate_user!
end
