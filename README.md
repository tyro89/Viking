# Viking

A familiar jRuby hdfs wrapper.

## Goal

The goal is to provide ways that are similar to the common ruby file system
api's for interacting with hdfs. All hdfs functionallity is powered by the java
hdfs classes.

## Status

### Available

 - `File`
 - `Dir`
 - `FileUtils`

### Not available yet but on the todo

 - `File#fnmatch`
 - `File#fnmatch?`
 - `Dir#glob`
 - `FileUtils#copy`

## Example usage

    # Set up hdfs config
    Viking.configure({
      host: '127.0.0.1',
      port: 54310
    })

    # If "/some/data" exists and it is a file then print its content. If it is
    # a directory then rename it. If it does not exist then we create it.
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
    else
      Viking::Dir.mkdir(path)
    end

