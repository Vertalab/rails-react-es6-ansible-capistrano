server 'SERVER IP', roles: [:web, :app, :db], primary: true

set :repo_url,        'git@bitbucket.org:example/example.git'
set :application,     'application_name'
set :branch,          'master'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

set :rbenv_ruby,      '2.3.1'
set :pty,             true
set :use_sudo,        true
set :stage,           :staging
set :deploy_via,      :remote_cache
set :deploy_to,       "/var/www/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

set :nvm_type, :user
set :nvm_node, 'v6.3.0'
set :nvm_map_bins, %w(node npm)

set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false

## Linked Files & Directories (Default None):
set :linked_files, %w(config/database.yml config/secrets.yml)
set :linked_dirs,  %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle
                      public/system node_modules client/node_modules)

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  # before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
