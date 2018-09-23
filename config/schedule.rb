# frozen_string_literal: true

set :output, File.join(Whenever.path, 'log', 'cron.log')

every 5.minutes do
  runner 'Practices::FinishOldJob.perform_later'
end
