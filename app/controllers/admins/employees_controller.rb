# frozen_string_literal: true

module Admins
  # Admin controller for managing employee
  class EmployeesController < AdminsController
    before_action :employee, only: %i[show edit update destroy]

    def index
      employee_query = EmployeeQuery.new(@hotel, params)
      @pagy, @employees = pagy(employee_query.call, limit: 10)
    end

    def show; end

    def new
      @employee = @hotel.employees.new
      @employee.build_profile
      @employee.profile.addresses.build
    end

    def edit; end

    def create
      @employee = @hotel.employees.build(employee_params)
      if @employee.save
        flash[:notice] = I18n.t('employee.create.success')
        redirect_to admins_employees_path
      else
        flash[:alert] = I18n.t('employee.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      destroy_all_documents
      if @employee.update(employee_params)
        flash[:notice] = I18n.t('employee.update.success')
        redirect_to admins_employee_path(@employee)
      else
        flash[:alert] = I18n.t('employee.update.error')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @employee.destroy
      flash[:notice] = I18n.t('employee.destroy.success')
      redirect_to admins_employees_path
    end

    private

    def employee
      @employee ||= @hotel.employees.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = I18n.t('employee.not-found')
      redirect_to admins_employees_path
    end

    def destroy_all_documents
      @employee.documents.destroy_all
    end

    def employee_params
      params.require(:employee).permit(
        :email,
        documents: [],
        profile_attributes: [
          :id, :avatar, :first_name, :last_name, :cid_no,
          :contact_no, :designation, :date_of_joining, :dob, :qualification, :salary,
          { addresses_attributes: %i[id dzongkhag gewog street_address address_type] }
        ]
      )
    end
  end
end
