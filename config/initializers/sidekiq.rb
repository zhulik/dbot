# frozen_string_literal: true

SCHEDULE_FILE = 'config/schedule.yml'

Sidekiq::Cron::Job.load_from_hash(YAML.load_file(SCHEDULE_FILE)) if File.exist?(SCHEDULE_FILE) && Sidekiq.server?

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL'), namespace: 'dbot' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL'), namespace: 'dbot' }
end
