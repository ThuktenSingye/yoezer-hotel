class FeedbackWorker
  include Sidekiq::Job

  def perform(booking)
    booking.update(feedback_expires_at: 2.minutes.from_now)
    CheckoutMailer.checkout_email(booking).deliver_later(queue: 'mailers')
  end
end
