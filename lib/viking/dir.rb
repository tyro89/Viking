module Viking
  class Dir

    def self.format(dirname)
      dirname.to_s.sub(/^[^:]*:\/*\//, '/')
    end

    def self.chdir(dirname=home, &block)
      if block
        main_dirname = pwd
        Viking.client.set_working_directory(Path.new(dirname))

        result = yield dirname

        Viking.client.set_working_directory(Path.new(main_dirname))
        result
      else
        Viking.client.set_working_directory(Path.new(dirname))
        0
      end
    end

    def self.delete(dirname)
      if exist?(dirname)
        Viking.client.delete(Path.new(dirname), false)
        0
      else
        raise Errno::ENOENT.new("No such file or directory - No such directory: #{dirname}")
      end
    end

    def self.entries(dirname)
      if exist?(dirname)
        iterator = Viking.client.list_located_status(Path.new(dirname))
        entries  = []

        while(iterator.has_next) do
          entry = format(iterator.next.path)
          entries << Viking::File.basename(entry)
        end

        entries
      else
        raise Errno::ENOENT.new("No such file or directory - No such directory: #{dirname}")
      end
    end

    def self.exist?(dirname)
      Viking::File.exist?(dirname) && Viking::File.directory?(dirname)
    end

    def self.exists?(dirname)
      exist?(dirname)
    end

    def self.foreach(dirname)
      entries(dirname).each { |entry| yield entry }
    end

    def self.getwd
      format(Viking.client.get_working_directory)
    end

    def self.home
      format(Viking.client.get_home_directory)
    end

    def self.mkdir(dirname)
      Viking.client.mkdirs(Path.new(dirname))
      0
    end

    def self.open(dirname, &block)
      dir = Viking::Dir.new(dirname)
      if block
        value = yield dir
        dir.close
        value
      else
        dir
      end
    end

    def self.pwd
      getwd
    end

    def self.rmdir(dirname)
      delete(dirname)
    end

    def initialize(path)
      @path   = path
      @closed = false
    end

    def close
      check_closed
      @closed = true
    end

    def each
      check_closed
      entries.each do |file_name|
        yield file_name
      end
    end

    def path
      @path
    end

    def read
      check_closed
      rewind if @entries.nil?
      entry = @entries[@pos]
      @pos += 1 unless entry.nil?
      entry
    end

    def rewind
      check_closed
      @pos     = 0
      @entries = entries
    end

    private

    def check_closed
      raise IOError.new("closed directory") if @closed
    end

    def entries
      Viking::Dir.entries(path)
    end
  end
end
