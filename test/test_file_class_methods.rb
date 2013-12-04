require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/viking.rb', __FILE__)

class TestFileClassMethods < MiniTest::Unit::TestCase

  TMP_DIR          = "/tmp/viking"
  TEST_FILE_1      = "test_file_1.rb"
  TEST_FILE_2      = "test_file_2.rb"
  TEST_FILE_PATH_1 = "#{TMP_DIR}/#{TEST_FILE_1}"
  TEST_FILE_PATH_2 = "#{TMP_DIR}/#{TEST_FILE_2}"

  def setup
    FileUtils.mkpath(TMP_DIR) unless File.exists?(TMP_DIR)
    FileUtils.touch(TEST_FILE_PATH_1)
    FileUtils.touch(TEST_FILE_PATH_2)
    File.write(TEST_FILE_PATH_2, "test")
  end

  def teardown
    FileUtils.remove_dir(TMP_DIR) if File.exists?(TMP_DIR)
  end

  def test_absolute_path
    same_level    = "foo.rb"
    up_level      = "../../foo.rb"
    up_down_level = "../bar/biz/foo.rb"

    assert File.absolute_path(same_level)    == Viking::File.absolute_path(same_level)
    assert File.absolute_path(up_level)      == Viking::File.absolute_path(up_level)
    assert File.absolute_path(up_down_level) == Viking::File.absolute_path(up_down_level)
  end

  def test_basename
    assert TEST_FILE_1                == Viking::File.basename(TEST_FILE_PATH_1)
    assert TEST_FILE_2.sub(".rb", "") == Viking::File.basename(TEST_FILE_PATH_2, ".rb")
  end

  def test_chmod
    assert 1     == Viking::File.chmod(777, TEST_FILE_PATH_1)
    assert 33545 == File.stat(TEST_FILE_PATH_1).mode
  end

  def test_chown
    assert 1 == Viking::File.chown(ENV["USER"], nil, TEST_FILE_PATH_1)
  end

  def test_delete
    assert 2 == Viking::File.delete(TEST_FILE_PATH_1, TEST_FILE_PATH_2)
    assert_raises(IOError) { Viking::File.delete(TMP_DIR) }
  end

  def test_directory?
    assert Viking::File.directory?(TMP_DIR)
    assert !Viking::File.directory?(TEST_FILE_PATH_1)
  end

  def test_exist?
    assert Viking::File.exists?(TEST_FILE_PATH_1)
    assert Viking::File.exists?(TMP_DIR)
    assert !Viking::File.exists?("#{TEST_FILE_PATH_1}foobar")
  end

  def test_exists?
    assert Viking::File.exists?(TEST_FILE_PATH_1)
    assert Viking::File.exists?(TMP_DIR)
    assert !Viking::File.exists?("#{TEST_FILE_PATH_1}foobar")
  end

  def test_file?
    assert !Viking::File.file?(TMP_DIR)
    assert Viking::File.file?(TEST_FILE_PATH_1)
  end

  def test_ftype
    assert 'directory' == Viking::File.ftype(TMP_DIR)
    assert 'file'      == Viking::File.ftype(TEST_FILE_PATH_1)
  end

  def test_move
    Viking::File.move(TEST_FILE_PATH_1, "#{TEST_FILE_PATH_1}.new")

    assert File.exists?("#{TEST_FILE_PATH_1}.new")
    assert !File.exists?(TEST_FILE_PATH_1)
  end

  def test_open
    f = Viking::File.open(TEST_FILE_PATH_1) do |file|
      file
    end

    assert f.instance_of? Viking::File
  end

  def test_rename
    Viking::File.rename(TEST_FILE_PATH_1, "#{TEST_FILE_PATH_1}.new")

    assert File.exists?("#{TEST_FILE_PATH_1}.new")
    assert !File.exists?(TEST_FILE_PATH_1)
  end

  def test_size
    assert 4 == Viking::File.size(TEST_FILE_PATH_2)
    assert_raises(Java::JavaIo::FileNotFoundException) { Viking::File.size("#{TMP_DIR}/does_not_exists") }
  end

  def test_size?
    assert 4 == Viking::File.size?(TEST_FILE_PATH_2)
    assert Viking::File.size?("#{TMP_DIR}/does_not_exists").nil?
  end

  def test_split
    assert [TMP_DIR, TEST_FILE_1] == Viking::File.split(TEST_FILE_PATH_1)
  end
end
