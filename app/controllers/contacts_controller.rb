# frozen_string_literal: true

class ContactsController < HomeController
  def index
    @feedback = @hotel.feedbacks.new
  end
end
