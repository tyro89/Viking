require "lock_jar"

LockJar.load

module Viking

  java_import java.net.URI
  java_import org.apache.hadoop.fs.FileSystem
  java_import org.apache.hadoop.hdfs.DistributedFileSystem
  java_import org.apache.hadoop.conf.Configuration
  java_import org.apache.hadoop.fs.Path
  java_import org.apache.hadoop.fs.permission.FsPermission

  DEFAULT_BUFFER_SIZE = 4096

  def self.configure(config)
    hostname     = config[:host]
    port         = config[:port]
    @buffer_size = config[:buffer_size]

    path = URI.new("hdfs://#{hostname}:#{port}")

    @client = DistributedFileSystem.new
    @client.initialize__method(path, Configuration.new)
  end

  def self.client
    @client ||= FileSystem.get_local(Configuration.new)
  end

  def self.buffer_size
    @buffer_size || DEFAULT_BUFFER_SIZE
  end
end

require "viking/version"
require 'viking/file'
require 'viking/dir'
require 'viking/fileutilz'
