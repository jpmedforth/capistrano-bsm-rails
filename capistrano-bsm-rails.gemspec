# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.1'
  s.required_rubygems_version = ">= 1.3.6"

  s.name        = "capistrano-bsm-rails"
  s.summary     = "Capistrano rails helpers"
  s.description = s.summary.dup
  s.version     = "0.1.1"

  s.authors     = ["Black Square Media"]
  s.email       = "info@blacksquaremedia.com"
  s.homepage    = "https://github.com/bsm/capistrano-bsm"

  s.require_path = 'lib'
  s.files        = Dir['lib/**/*']

  s.add_dependency "capistrano", "< 3.0.0"
end
