Sentry.init do |config|
  config.dsn = 'https://76a38db6c3ff895241c5bb503cadbf25@o4506522011041792.ingest.sentry.io/4506522011107328'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.enabled_environments = %w[production]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 1.0
  # or
  # config.traces_sampler = lambda do |context|
  #   true
  # end
end
