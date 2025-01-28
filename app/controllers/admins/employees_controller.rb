# frozen_string_literal: true

module Admins
  class EmployeesController < AdminsController
    before_action :hotel
    before_action :employee, only: %i[show edit update destroy]
    def index
      @employees = @hotel.employees.order(created_at: :desc)
    end

    def show; end

    def new; end

    def edit; end

    def create
      @employee = @hotel.employees.build(employee_params)
      if @employee.save
        flash[:notice] = I18n.t('employee.create.success')
        redirect_to admins_hotel_employees_path(@hotel)
      else
        flash[:alert] = I18n.t('employee.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      # binding.pry
      if @employee.update(employee_params)
        flash[:notice] = I18n.t('employee.update.success')
        redirect_to admins_hotel_employees_path(@hotel)
      else
        flash[:alert] = I18n.t('employee.update.error')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @employee.destroy
      flash[:notice] = I18n.t('employee.destroy.success')
      redirect_to admins_hotel_employees_path(@hotel)
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:hotel_id])
    end

    def employee
      @employee ||= Employee.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = I18n.t('employee.not-found')
      redirect_to admins_hotel_employees_path(@hotel)
    end

    def employee_params
      params.require(:employee).permit(:email, contract_files: [],
                                               profile_attributes: [:avatar, :first_name, :last_name, :cid_no, :contact_no, :designation, :date_of_joining, :dob, :qualification, :salary,
                                                                    { addresses_attributes: %i[id dzongkhag gewog street_address address_type] }])
    end
  end
end
