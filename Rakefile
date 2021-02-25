require "bundler"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = "spec/*_spec.rb"
  t.verbose = false
end

task :default => :test

task :generate do
  [
    "./bin/swaggery --file=./examples/spec --output=./tmp/spec.json",
    "openapi lint --format=stylish ./tmp/spec.json",
    "openapi stats ./tmp/spec.json",
  ].each do |cmd|
    puts `#{cmd}`
  end
end

task preview: :generate do
  exec "openapi preview-docs ./tmp/spec.json"
end