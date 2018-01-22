
# frozen_string_literal: true

every 2.minutes do
  runner 'MyModel.some_method'
end
