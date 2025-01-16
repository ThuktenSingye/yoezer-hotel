class Admin::ProfilesController < AdminController
  before_action :set_profile, only: [ :index, :edit, :update ]

  def index; end

  def edit; end

  def update
    # binding.pry
    if @profile.update(profile_params)
      redirect_to admin_profiles_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile ||= current_admin.profile
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :cid_no, :contact_no, :designation, :date_of_joining, :dob, :qualification, :salary)
  end
end
