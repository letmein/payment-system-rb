# frozen_string_literal: true

ENV.each_key do |key|
  env key.to_sym, ENV[key]
end

env :GEM_PATH, '/usr/local/bundle'

set :environment, ENV['RAILS_ENV']
set :output, '/var/log/cron.log'

every 1.hour do
  rake 'transactions:cleanup'
end
