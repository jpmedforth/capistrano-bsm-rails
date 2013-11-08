require 'capistrano'
require 'bundler/capistrano'

Capistrano::Configuration.instance(:must_exist).load do

  _cset(:rails_env) { fetch(:rails_env) || fetch(:stage) }

  desc "Run an app console on primary app tier"
  task :console, roles: :app, only: { primary: true } do
    hostname = find_servers_for_task(current_task).first
    cmd = "cd #{current_path} && #{bundle_cmd} exec rails c #{rails_env}"
    exec "ssh #{hostname} -t '#{cmd}'"
  end

  desc "Run rake tasks on primary app tier via CMD='task1 task2'"
  task :rake, roles: :app, only: { primary: true } do
    abort "Please provide a CMD env var, e.g. CMD='db:mirate'" unless ENV['CMD']

    hostname = find_servers_for_task(current_task).first
    cmd = "cd #{current_path} && #{bundle_cmd} exec rake #{ENV['CMD']} RAILS_ENV=#{rails_env}"
    exec "ssh #{hostname} -t '#{cmd}'"
  end

  # Maintenance tasks
  namespace :maintenance do

    desc "Enable maintenance"
    task :on, roles: :web do
      run "touch #{shared_path}/pids/maintenance.lock"
    end

    desc "Disable maintenance"
    task :off, roles: :web do
      run "rm -f #{shared_path}/pids/maintenance.lock"
    end

  end

  # Log tasks
  namespace :log do

    desc "Tail application logs"
    task :tail, roles: :app do
      run "tail -f #{shared_path}/log/*.log" do |channel, stream, data|
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end

  end

end
