require "capistrano"
require "capistrano/configuration"

Capistrano::Configuration.instance.load do

  desc "Run an app console on primary app tier"
  task :console, roles: :app, only: { primary: true } do
    hostname = find_servers_for_task(current_task).first
    cmd = "cd #{current_path} && #{bundle_cmd} exec rails c #{stage}"
    exec "ssh #{hostname} -t '#{cmd}'"
  end

  desc "Run rake tasks on primary app tier via CMD='task1 task2'"
  task :rake, roles: :app, only: { primary: true } do
    hostname = find_servers_for_task(current_task).first
    abort "Please provide a CMD env var, e.g. CMD='db:mirate'" unless ENV['CMD']
    cmd = "cd #{current_path} && #{bundle_cmd} exec rake #{ENV['CMD']} RAILS_ENV=#{stage}"
    exec "ssh #{hostname} -t '#{cmd}'"
  end

  # Maintenance tasks
  namespace :maintenance do

    desc "Enable maintenance"
    task :on, roles: :app do
      run "touch #{shared_path}/pids/maintenance.lock"
    end

    desc "Disable maintenance"
    task :off, roles: :app do
      run "rm -f #{shared_path}/pids/maintenance.lock"
    end

  end

  # Log tasks
  namespace :log do

    desc "Tail application logs"
    task :tail, :roles => :app do
      run "tail -f #{shared_path}/log/*.log" do |channel, stream, data|
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end

  end

end
