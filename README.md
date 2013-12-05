# Viking

jRuby hdfs wrapper attempting to provide an interface that's similar to the common ruby file system api's.

## Status

### Available

 - File
 - Dir

### Not available yet

 - FileUtils
 - FileStat

## Example usage

    # Set up hdfs config
    Viking.configure({
      host: '127.0.0.1',
      port: 54310
    })

    # If "/some/data" exists then print the content if it is a file
    # or otherwise rename it if it's a directory.
    path = "/some/data"
    if Viking::File.exists? path
      if Viking::File.file? path
        Viking::File.open(path) do |file|
          puts "Reading data from #{f.path}:"
          puts f.read
        end
      else
        Viking::File.rename(path, "/some/dir")
      end
    end
