require "bundler/gem_tasks"

require 'cucumber/rake/task'
Cucumber::Rake::Task.new('spec:features') do |t|
  t.cucumber_opts = "features --format pretty"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => ['spec', 'spec:features']
