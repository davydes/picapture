require_relative 'config/application'
require 'rspec/core/rake_task'
require 'resque/tasks'

Rails.application.load_tasks

RSpec::Core::RakeTask.new(:spec)
task :default => :spec
