# frozen_string_literal: true

# Base mailer class for the application with default settings
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
