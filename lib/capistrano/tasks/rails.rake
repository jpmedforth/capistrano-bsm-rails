desc "Run an app console on primary app tier"
task :console => [:set_rails_env] do
  on primary :app do
    hostname = find_servers_for_task(current_task).first
    cmd = "cd #{current_path} && bundle exec rails c #{rails_env}"
    exec "ssh #{hostname} -t '#{cmd}'"
  end
end

desc "Run rake tasks on primary app tier via CMD='task1 task2'"
task :raketask => [:set_rails_env] do
  abort "Please provide a CMD env var, e.g. CMD='db:mirate'" unless ENV['CMD']
  on primary :app do
    hostname = find_servers_for_task(current_task).first
    cmd = "cd #{current_path} && bundle exec rake #{ENV['CMD']} RAILS_ENV=#{rails_env}"
    exec "ssh #{hostname} -t '#{cmd}'"
  end
end

# Maintenance tasks
namespace :maintenance do

  desc "Enable maintenance"
  task :on do
    on :web do
      run "touch #{shared_path}/pids/maintenance.lock"
    end
  end

  desc "Disable maintenance"
  task :off do
    on :web do
      run "rm -f #{shared_path}/pids/maintenance.lock"
    end
  end

end

# Log tasks
namespace :log do

  desc "Tail application logs"
  task :tail do
    on :app do
      run "tail -f #{shared_path}/log/*.log" do |channel, stream, data|
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end
  end

end
