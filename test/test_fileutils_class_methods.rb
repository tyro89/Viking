require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/viking.rb', __FILE__)

class TestFileUtilsClassMethods < MiniTest::Unit::TestCase

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

  def test_cd
    assert 0 == Viking::FileUtils.cd(TMP_DIR)
    assert Viking::Dir.pwd == TMP_DIR

    Viking::FileUtils.cd("/tmp") do |path|
      assert "/tmp" == path
      assert "/tmp" == Viking::Dir.pwd
    end

    assert Viking::Dir.pwd == TMP_DIR

    assert 0 == Viking::FileUtils.cd(Dir.pwd)
  end

  def test_chdir
    assert 0 == Viking::FileUtils.chdir(TMP_DIR)
    assert Viking::Dir.pwd == TMP_DIR

    Viking::FileUtils.chdir("/tmp") do |path|
      assert "/tmp" == path
      assert "/tmp" == Viking::Dir.pwd
    end

    assert Viking::Dir.pwd == TMP_DIR

    assert 0 == Viking::FileUtils.chdir(Dir.pwd)
  end

  def test_chmod
    Viking::FileUtils.chmod(777, [TEST_FILE_PATH_1, TEST_FILE_PATH_2])
    assert 33545 == File.stat(TEST_FILE_PATH_1).mode
    assert 33545 == File.stat(TEST_FILE_PATH_2).mode
  end

  def test_chown
    assert [TEST_FILE_PATH_1] == Viking::FileUtils.chown(ENV["USER"], nil, TEST_FILE_PATH_1)
  end

  def test_getwd
    assert Dir.pwd == Viking::FileUtils.getwd
  end

  def test_makedirs
    dirs = ["#{TMP_DIR}/foo", "#{TMP_DIR}/bar"]

    assert !Viking::Dir.exist?("#{TMP_DIR}/foo")
    assert !Viking::Dir.exist?("#{TMP_DIR}/bar")

    Viking::FileUtils.makedirs(dirs)

    assert Viking::Dir.exist?("#{TMP_DIR}/foo")
    assert Viking::Dir.exist?("#{TMP_DIR}/bar")
  end

  def test_mkdir
    dirs = ["#{TMP_DIR}/foo", "#{TMP_DIR}/bar"]

    assert !Viking::Dir.exist?("#{TMP_DIR}/foo")
    assert !Viking::Dir.exist?("#{TMP_DIR}/bar")

    Viking::FileUtils.mkdir(dirs)

    assert Viking::Dir.exist?("#{TMP_DIR}/foo")
    assert Viking::Dir.exist?("#{TMP_DIR}/bar")
  end

  def test_move
    assert !Viking::Dir.exist?("#{TMP_DIR}/foo")
    assert !Viking::Dir.exist?("#{TMP_DIR}/bar")

    Dir.mkdir("#{TMP_DIR}/foo")

    assert Viking::Dir.exist?("#{TMP_DIR}/foo")
    assert !Viking::Dir.exist?("#{TMP_DIR}/bar")

    Viking::FileUtils.move("#{TMP_DIR}/foo", "#{TMP_DIR}/bar")

    assert !Viking::Dir.exist?("#{TMP_DIR}/foo")
    assert Viking::Dir.exist?("#{TMP_DIR}/bar")
  end

  def test_mv
    assert !Viking::Dir.exist?("#{TMP_DIR}/foo")
    assert !Viking::Dir.exist?("#{TMP_DIR}/bar")

    Dir.mkdir("#{TMP_DIR}/foo")

    assert Viking::Dir.exist?("#{TMP_DIR}/foo")
    assert !Viking::Dir.exist?("#{TMP_DIR}/bar")

    Viking::FileUtils.mv("#{TMP_DIR}/foo", "#{TMP_DIR}/bar")

    assert !Viking::Dir.exist?("#{TMP_DIR}/foo")
    assert Viking::Dir.exist?("#{TMP_DIR}/bar")
  end

  def test_pwd
    assert Dir.pwd == Viking::FileUtils.pwd
  end

  def test_remove
    Viking::FileUtils.remove([TEST_FILE_PATH_1, TEST_FILE_PATH_2])

    assert !File.exist?(TEST_FILE_PATH_1)
    assert !File.exist?(TEST_FILE_PATH_2)

    assert_raises(IOError) { Viking::FileUtils.remove(TMP_DIR) }
  end

  def test_remove_dir
    assert_raises(Java::JavaIo::IOException) { Viking::FileUtils.remove_dir(TMP_DIR) }

    Dir.mkdir("#{TMP_DIR}/foo")
    assert Dir.exist?("#{TMP_DIR}/foo")

    Viking::FileUtils.remove_dir("#{TMP_DIR}/foo")

    assert !Dir.exist?("#{TMP_DIR}/foo")
  end

  def test_remove_entry
    Viking::FileUtils.remove_entry(TMP_DIR)
    assert !Dir.exist?(TMP_DIR)
  end

  def test_remove_file
    Viking::FileUtils.remove_file(TEST_FILE_PATH_1)
    assert !File.exist?(TEST_FILE_PATH_1)
  end

  def test_rm
    Viking::FileUtils.rm([TEST_FILE_PATH_1, TEST_FILE_PATH_2])

    assert !File.exist?(TEST_FILE_PATH_1)
    assert !File.exist?(TEST_FILE_PATH_2)

    assert_raises(IOError) { Viking::FileUtils.rm(TMP_DIR) }
  end

  def test_rm_r
    Viking::FileUtils.rm_r(TMP_DIR)
    assert !Dir.exist?(TMP_DIR)
  end

  def test_rmdir
    assert_raises(Java::JavaIo::IOException) { Viking::FileUtils.rmdir(TMP_DIR) }

    Dir.mkdir("#{TMP_DIR}/foo")
    Dir.mkdir("#{TMP_DIR}/bar")
    assert Dir.exist?("#{TMP_DIR}/foo")
    assert Dir.exist?("#{TMP_DIR}/bar")

    Viking::FileUtils.rmdir(["#{TMP_DIR}/foo", "#{TMP_DIR}/bar"])

    assert !Dir.exist?("#{TMP_DIR}/foo")
    assert !Dir.exist?("#{TMP_DIR}/bar")
  end

  def test_touch
    assert !File.exist?("#{TMP_DIR}/foo.test")
    assert !File.exist?("#{TMP_DIR}/bar.test")

    Viking::FileUtils.touch(["#{TMP_DIR}/foo.test", "#{TMP_DIR}/bar.test"])

    assert File.exist?("#{TMP_DIR}/foo.test")
    assert File.exist?("#{TMP_DIR}/bar.test")
  end
end
