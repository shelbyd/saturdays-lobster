require "bundler/gem_tasks"
require 'cucumber/rake/task'

Cucumber::Rake::Task.new('spec:features') do |t|
  t.cucumber_opts = "features --format pretty"
end

task :default => ['spec:features']
