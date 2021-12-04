Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins 'http://localhost:3000'
    origins '*'

    resource '*',
             headers: :any,
             expose: %w[access-token expiry token-type uid client],
             methods: [:get, :post, :options, :delete, :put]
  end
end
