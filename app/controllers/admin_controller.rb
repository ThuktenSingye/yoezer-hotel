class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    @hotel = Hotel.first
  end
end
