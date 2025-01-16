class Admin::ProfilesController < ApplicationController
  layout 'admin'

  before_action :authenticate_admin!
  before_action :set_profile, only: [:index, :edit, :update ]

  def index; end

  def edit
    if @profile.update(profile_params)
      redirect_to admin_profile_path(current_admin)
    else
      redirect_to admin_profile_path(current_admin), status: :unprocessable_entity
    end
  end

  def update

  end

  private

  def set_profile
    @profile ||= current_admin.profile
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :cid_no, :designation, :date_of_joining, :dob, :qualification, :salary,)
  end
end
