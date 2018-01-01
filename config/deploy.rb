# frozen_string_literal: true

set :migration_role, :app
set :rails_env, 'production'

set :application, 'dbot'
set :repo_url,    'git@github.com:zhulik/dbot'

set :migration_servers, -> { primary(fetch(:migration_role)) }
set :conditionally_migrate, true
set :pty, true
set :assets_roles, %i[web app]

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
set :normalize_asset_timestamps, %w(public/images public/javascripts public/stylesheets)

set :keep_assets, 2

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle',
       'public/system', 'public/uploads', 'public/assets'
append :linked_files, 'config/database.yml', 'config/secrets.yml'

set :ssh_options, forward_agent: true

set :rvm_ruby_version, 'ruby-2.4.2@dbot --create'

set :whenever_roles, %w(schedule)
