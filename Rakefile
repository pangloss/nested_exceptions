require "bundler/gem_tasks"

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.ruby_opts = '--debug'
  spec.skip_bundler = true
  spec.rcov = true
  spec.rcov_opts = %w{--exclude generator_internal,jsignal_internal,gems\/,spec\/}
end

task :default => :spec
