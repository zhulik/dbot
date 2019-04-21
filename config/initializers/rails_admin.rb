# frozen_string_literal: true

RailsAdmin.config do |config|
  AUTH_HASH = 'a86cbc3d8a195be4e39bb4ef5493cae7587747f6f76848646817e19710d14719'

  config.authenticate_with do
    next Struct.new(:email).new('zhulik.gleb@gmail.com') unless Rails.env.production?

    authenticate_or_request_with_http_basic('Login required') do |username, password|
      salt = Rails.application.secrets.rails_admin_salt
      if ActiveSupport::SecurityUtils.secure_compare(Digest::SHA256.hexdigest("#{username}:#{password}:#{salt}"),
                                                     AUTH_HASH)
        Struct.new(:email).new('zhulik.gleb@gmail.com')
      end
    end
  end
  config.total_columns_width = 1300

  config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
