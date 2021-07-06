# frozen_string_literal: true

port        ENV.fetch('PUMA_PORT', 3000)

environment ENV.fetch('RAILS_ENV', 'development')

workers ENV.fetch('PUMA_WORKERS', 2)
threads ENV.fetch('PUMA_THREADS_MIN', 2), ENV.fetch('PUMA_THREADS_MAX', 10)

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
