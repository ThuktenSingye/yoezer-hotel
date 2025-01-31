# frozen_string_literal: true

# config/initializers/redis.rb
require 'redis'

# Initialize Redis connection using the URL from the environment variable
REDIS = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))
