require 'simplecov'
SimpleCov.start do
  add_group 'API', 'app/api'
  add_group 'Models', 'app/models'
  add_group 'Queries', 'app/queries'
  add_group 'Services', 'app/services'
  add_group 'Serializers', 'app/serializers'
  add_group 'Uploaders', 'app/uploaders'
  add_group 'Validators', 'app/validators'
  add_group 'Policies', 'app/policies'
  add_group 'Libs', 'lib'
  add_filter 'app/models/legacy/temporary'
  add_filter 'spec'
  add_filter 'models/concerns'
  add_filter 'config'
  command_name 'RSpec'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run_when_matching :focus

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random
  Kernel.srand config.seed
end