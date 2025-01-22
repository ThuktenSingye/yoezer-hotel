# frozen_string_literal: true

# Session
module Admins
  # Handle admins session management (sign in and sign out)
  class SessionsController < Devise::SessionsController
    layout 'devise'
  end
end
