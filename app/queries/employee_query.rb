# frozen_string_literal: true

# Employee Query Class
class EmployeeQuery < BaseQuery
  def call
    employees = @hotel.employees.joins(:profile)
    employees = filter_by_designation(employees) if @params[:designation].present?
    employees = search_by_query(employees) if @params[:query].present?

    employees.includes(:profile).order(created_at: :desc)
  end

  private

  def filter_by_designation(employees)
    designation_key = @params[:designation]

    if Profile.designations.key?(designation_key)
      employees.where(profiles: { designation: Profile.designations[designation_key] })
    else
      employees.none
    end
  end

  def search_by_query(employees)
    query = "%#{@params[:query]}%"
    employees.where(
      'profiles.first_name ILIKE :query OR profiles.last_name ILIKE :query OR
      profiles.cid_no ILIKE :query OR profiles.contact_no ILIKE :query',
      query: query
    )
  end
end
