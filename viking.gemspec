# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'viking/version'

Gem::Specification.new do |spec|
  spec.name          = "hdfs-viking"
  spec.version       = Viking::VERSION
  spec.authors       = ["Erik Selin"]
  spec.email         = ["erik.selin@jadedpixel.com"]
  spec.description   = %q{jruby hdfs wrapper attempting to provide an interface that's similar to the common ruby file system api's.}
  spec.summary       = %q{jruby hdfs wrapper}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.extensions    = ["Rakefile"]

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3.5"
  spec.add_development_dependency "rake"

  spec.add_dependency "lock_jar"
end
