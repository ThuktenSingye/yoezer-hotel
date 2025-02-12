# frozen_string_literal: true

# Contact us page controller
class ContactsController < HomeController
  def index
    @feedback = @hotel.feedbacks.new
  end
end
