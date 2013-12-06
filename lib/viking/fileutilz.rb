module Viking
  module FileUtils

    def self.cd(dirname, &block)
      if block
        Viking::Dir.chdir(dirname, &block)
      else
        Viking::Dir.chdir(dirname)
      end
    end

    def self.chdir(dirname, &block)
      cd(dirname, &block)
    end

    def self.chmod(mode, list)
      list = (list.is_a? Array) ? list : [list]
      list.each do |path|
        Viking::File.chmod(mode, path)
      end
    end

    def self.chown(user, group, list)
      list = (list.is_a? Array) ? list : [list]
      list.each do |dir|
        Viking::File.chown(user, group, dir)
      end
    end

    def self.getwd
      Viking::Dir.getwd
    end

    def self.makedirs(list)
      list = (list.is_a? Array) ? list : [list]
      list.each do |dir|
        Viking::Dir.mkdir(dir)
      end
    end

    def self.mkdir(list)
      makedirs(list)
    end

    def self.move(src, dst)
      Viking::File.move(src, dst)
    end

    def self.mv(src, dst)
      move(src, dst)
    end

    def self.pwd
      getwd
    end

    def self.remove(list)
      list = (list.is_a? Array) ? list : [list]
      list.each do |dir|
        remove_file(dir)
      end
    end

    def self.remove_dir(path)
      Viking::Dir.delete(path)
    end

    def self.remove_entry(path)
      rm_r(path)
    end

    def self.remove_file(path)
      Viking::File.delete(path)
    end

    def self.rm(list)
      remove(list)
    end

    def self.rm_r(list)
      list = (list.is_a? Array) ? list : [list]
      list.each do |path|
        Viking.client.delete(Path.new(path), true)
      end
    end

    def self.rmdir(list)
      list = (list.is_a? Array) ? list : [list]
      list.each do |dir|
        remove_dir(dir)
      end
    end

    def self.touch(list)
      list = (list.is_a? Array) ? list : [list]
      list.each do |path|
        Viking.client.create_new_file(Path.new(path))
      end
    end
  end
end
