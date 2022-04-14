# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

#basic configuration
set :application, "tracker7os"
set :repo_url, "git@github.com:usingnow/tracker7os.git"
set :deploy_user, "hp00535"
set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:application)}"
set :deploy_via, "remote_cache" #本地cache, 第一次是git clone,后面是git pull

#rbenv
set :rbenv_type, :user
set :rbenv_ruby, '3.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# Default value for keep_releases is 5
set :keep_releases, 10

#------------
#db:migrate & assets configuration

# If the environment differs from the stage name
set :rails_env, 'production'

# Defaults to :db role
set :migration_role, :db

# Defaults to the primary :db server
set :migration_servers, -> { primary(fetch(:migration_role)) }

# Defaults to `db:migrate`
set :migration_command, 'db:migrate'

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# Defaults to [:web]
set :assets_roles, [:web, :app]

# Defaults to 'assets'
# This should match config.assets.prefix in your rails config/application.rb
set :assets_prefix, 'prepackaged-assets'

# Defaults to ["/path/to/release_path/public/#{fetch(:assets_prefix)}/.sprockets-manifest*", "/path/to/release_path/public/#{fetch(:assets_prefix)}/manifest*.*"]
# This should match config.assets.manifest in your rails config/application.rb
set :assets_manifests, ['app/assets/config/manifest.js']

# RAILS_GROUPS env value for the assets:precompile task. Default to nil.
set :rails_assets_groups, :assets

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
#set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}

# Defaults to nil (no asset cleanup is performed)
# If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# set this to the number of versions to keep
set :keep_assets, 10
#-------------

set :passenger_roles, :app

# files we want symlinking to specific entries in shared
#set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml config/credentials.yml.enc}
set :linked_files, %w{config/master.key config/credentials.yml.enc config/database.yml}
# dirs we want symlinking to shared
#set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_shell, '/bin/bash -l'
task :rebootweb do
  on roles(:app) do |host|
    execute "echo Michelin!1 | sudo -S service nginx restart"
  end
end

namespace :deploy do
  after :finishing, 'rebootweb'
  after :finishing, 'deploy:cleanup'
end

