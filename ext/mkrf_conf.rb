require 'lock_jar'
jarfile  = File.expand_path("../Jarfile", File.dirname(__FILE__))
LockJar.lock(jarfile)
