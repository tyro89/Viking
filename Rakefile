#!/usr/bin/env rake

require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/viking'
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end

task :prepare do
  require 'lock_jar'
  LockJar.lock
  lockfile = File.expand_path( "../Jarfile.lock", __FILE__ )
  LockJar.install( :lockfile => lockfile )
end

task :default => :prepare
