if defined?(Capistrano::Configuration) && Capistrano::Configuration.instance
  require "capistrano/bsm/rails"
end
