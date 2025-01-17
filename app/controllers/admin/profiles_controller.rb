class Admin::ProfilesController < AdminController
  before_action :set_profile, only: [ :index, :edit, :update ]

  def index; end

  def edit; end

  def update
    if @profile.update(profile_params.except(:avatar))
      if profile_params[:avatar].present?
        @profile.avatar.attach(profile_params[:avatar])
      end
      respond_to do |format|
        format.html { redirect_to admin_profiles_path }
        format.turbo_stream do
          flash.now[:notice] = "Profile was successfully updated."
          render turbo_stream: [
            turbo_stream.replace("avatar", partial: "admin/profiles/avatar", locals: { profile: @profile }),
            turbo_stream.replace(@profile, partial: "admin/profiles/profile", locals: { profile: @profile }),
            turbo_stream.prepend("flash", partial: "layouts/flash")
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_profiles_path, status: :unprocessable_content }
        format.turbo_stream do
          flash.now[:alert] = "Error updating Profile"
          render turbo_stream: [
            turbo_stream.replace(@profile, partial: "admin/profiles/form", locals: { profile: @profile }),
            turbo_stream.prepend("flash", partial: "layouts/flash")
          ]
        end
      end
    end
  end

  private

  def set_profile
    @profile ||= current_admin.profile
  end

  def profile_params
    params.require(:profile).permit(:avatar, :first_name, :last_name, :cid_no, :contact_no, :designation, :date_of_joining, :dob, :qualification, :salary, addresses_attributes: [ :id, :dzongkhag, :gewog, :street_address, :address_type ])
  end
end
