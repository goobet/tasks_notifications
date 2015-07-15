Sidekiq.configure_server do |config|
  if Rails.env.production?
    config.redis = { 
      url: ENV['REDIS_URL'], 
      network_timeout: 5 
    }
  end
end

Sidekiq.configure_client do |config|
  if Rails.env.production?
    config.redis = { 
      url: ENV['REDIS_URL'], 
      network_timeout: 5 
    }
  end
end