require 'lock_jar'
jarfile  = File.expand_path("../Jarfile", File.dirname(__FILE__))
lockfile = File.expand_path("../Jarfile.lock", File.dirname(__FILE__))
LockJar.lock(jarfile)
LockJar.install(lockfile)
