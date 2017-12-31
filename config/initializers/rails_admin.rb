# frozen_string_literal: true

RailsAdmin.config do |config|
  ### Popular gems integration

  config.authenticate_with do
    authenticate_or_request_with_http_basic('Login required') do |_username, _password|
      Struct.new(:email).new('zhulik.gleb@gmail.com')
    end
  end

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
