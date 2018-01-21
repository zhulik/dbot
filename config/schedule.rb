# frozen_string_literal: true

set :output, File.join(Whenever.path, 'log', 'cron.log')

every 2.minutes do
  runner 'Practices::FinishOldJob.perform_later'
end
