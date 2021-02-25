require "bundler"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = "spec/*_spec.rb"
  t.verbose = false
end

task :default => :test

task :demo do
  puts `./bin/swaggery --file=./examples/spec --output=./tmp/spec.json`
end