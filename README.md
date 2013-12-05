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

### Not available yet but on the todo

 - `FileUtils`
 - `File#fnmatch`
 - `File#fnmatch?`
 - `Dir#glob`

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

    # Print the current hdfs working directory and create a new tmp folder.
    puts Viking::Dir.pwd
    Viking::Dir.mkdir("/tmp")

