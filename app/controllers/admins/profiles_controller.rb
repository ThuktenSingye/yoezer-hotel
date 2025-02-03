# frozen_string_literal: true

module Admins
  # Manages profiles for admins in the admins interface
  class ProfilesController < AdminsController
    include ImageAttachment
    before_action :hotel
    before_action :profile, only: %i[index edit update]

    def index; end

    def edit; end

    def update
      if @profile.update(profile_params.except(:avatar))
        self.class.attach_image(@profile, profile_params, :avatar) # Attach avatar using
        success_response
      else
        failure_response
      end
    end

    private

    def hotel
      @hotel ||= current_admin.hotel
    end

    def profile
      @profile ||= current_admin.profile
    end

    def profile_params
      params.require(:profile).permit(:avatar, :first_name, :last_name, :cid_no, :contact_no, :designation,
                                      :date_of_joining, :dob, :qualification, :salary,
                                      addresses_attributes: %i[id dzongkhag gewog street_address address_type])
    end

    # rubocop:disable Metric/MethodLength
    def success_response
      respond_to do |format|
        format.html { redirect_to admins_profiles_path }
        format.turbo_stream do
          flash.now[:notice] = I18n.t('profile.update.success')
          render turbo_stream: [
            turbo_stream.replace('avatar', partial: 'admins/profiles/avatar', locals: { profile: @profile }),
            turbo_stream.replace(@profile, partial: 'admins/profiles/profile', locals: { profile: @profile }),
            turbo_stream.prepend('flash', partial: 'shared/flash')
          ]
        end
      end
    end
    # rubocop:enable Metric/MethodLength

    def failure_response
      respond_to do |format|
        format.html { redirect_to admins_profiles_path, status: :unprocessable_content }
        format.turbo_stream do
          flash.now[:alert] = I18n.t('profile.update.error')
          render turbo_stream: [
            turbo_stream.replace(@profile, partial: 'admins/profiles/form', locals: { profile: @profile }),
            turbo_stream.prepend('flash', partial: 'shared/flash')
          ]
        end
      end
    end
  end
end
