# frozen_string_literal: true

# Session
module Admin
  # Handle admin session management (sign in and sign out)
  class SessionsController < Devise::SessionsController
    layout 'devise'
  end
end
