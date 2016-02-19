server 'modsulator-app-stage.stanford.edu', user: fetch(:user), roles: %w{web db app}

set :rails_env, 'production'
set :bundle_without, %w(test development).join(' ')

Capistrano::OneTimeKey.generate_one_time_key!
