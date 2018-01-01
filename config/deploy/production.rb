# frozen_string_literal: true

server 'dbot.lighty.photo', user: 'zhulik', roles: %w(web app db worker schedule)

set :deploy_to, '/home/zhulik/dbot'
set :rails_env, 'production'
