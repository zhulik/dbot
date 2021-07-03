# frozen_string_literal: true

threads_count = 2
threads threads_count, threads_count

port        ENV.fetch('PORT', 3000)

environment ENV.fetch('RAILS_ENV', 'development')

workers ENV.fetch('WEB_CONCURRENCY', 2)

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

plugin :tmp_restart
