#!/usr/bin/env rake

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/viking'
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end

task :prepare do
  load(File.expand_path("ext/mkrf_conf.rb", File.dirname(__FILE__)))
end

task :default => :test
