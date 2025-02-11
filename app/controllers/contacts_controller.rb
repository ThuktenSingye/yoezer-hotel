class ContactsController < HomeController
  def index
    @feedback = @hotel.feedbacks.new
  end
end
