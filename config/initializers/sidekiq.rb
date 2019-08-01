# frozen_string_literal: true

SCHEDULE_FILE = 'config/schedule.yml'

Sidekiq::Cron::Job.load_from_hash(YAML.load_file(SCHEDULE_FILE)) if File.exist?(SCHEDULE_FILE) && Sidekiq.server?
