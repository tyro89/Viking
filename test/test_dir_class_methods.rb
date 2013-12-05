require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/viking.rb', __FILE__)

class TestDirClassMethods < MiniTest::Unit::TestCase

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

  def test_chdir
    assert 0 == Viking::Dir.chdir(TMP_DIR)
    assert Viking::Dir.pwd == TMP_DIR

    Viking::Dir.chdir("/tmp") do |path|
      assert "/tmp" == path
      assert "/tmp" == Viking::Dir.pwd
    end

    assert Viking::Dir.pwd == TMP_DIR

    assert 0 == Viking::Dir.chdir(Dir.pwd)
  end

  def test_delete
    FileUtils.mkpath("#{TMP_DIR}/empty")

    assert_raises(Java::JavaIo::IOException) { Viking::Dir.delete(TMP_DIR) }
    assert_raises(Errno::ENOENT) { Viking::Dir.delete("#{TMP_DIR}/does-not-exists") }

    assert Dir.exist?("#{TMP_DIR}/empty")
    assert 0 == Viking::Dir.delete("#{TMP_DIR}/empty")
    assert !Dir.exist?("#{TMP_DIR}/empty")
  end

  def test_entries
    assert_raises(Errno::ENOENT) { Viking::Dir.delete("#{TMP_DIR}/does-not-exists") }
    assert_raises(Errno::ENOENT) { Viking::Dir.delete(TEST_FILE_PATH_1) }

    assert [TEST_FILE_1, TEST_FILE_2] == Viking::Dir.entries(TMP_DIR)
  end

  def test_exist?
    assert Viking::Dir.exist?(TMP_DIR)
    assert !Viking::Dir.exist?(TEST_FILE_PATH_1)
    assert !Viking::Dir.exist?("#{TMP_DIR}/does-not-exists")
  end

  def test_exists?
    assert Viking::Dir.exists?(TMP_DIR)
    assert !Viking::Dir.exists?(TEST_FILE_PATH_1)
    assert !Viking::Dir.exists?("#{TMP_DIR}/does-not-exists")
  end

  def test_foreach
    file_names = []
    Viking::Dir.foreach(TMP_DIR) do |file_name|
      file_names << file_name
    end
    assert [TEST_FILE_1, TEST_FILE_2] == file_names
  end

  def test_getwd
    assert Dir.pwd == Viking::Dir.getwd
  end

  def test_home
    assert Dir.home == Viking::Dir.home
  end

  def test_mkdir
    assert !Dir.exist?("#{TMP_DIR}/new/folder/struct")
    Viking::Dir.mkdir("#{TMP_DIR}/new/folder/struct")
    assert Dir.exist?("#{TMP_DIR}/new/folder/struct")
  end

  def test_open
    assert Viking::Dir.open(TMP_DIR).instance_of? Viking::Dir
    assert TMP_DIR == Viking::Dir.open(TMP_DIR).path

    Viking::Dir.open(TMP_DIR) do |dir|
      assert dir.instance_of? Viking::Dir
      assert TMP_DIR == dir.path
    end
  end

  def test_pwd
    assert Dir.pwd == Viking::Dir.pwd
  end

  def test_rmdir
    FileUtils.mkpath("#{TMP_DIR}/empty")

    assert_raises(Java::JavaIo::IOException) { Viking::Dir.delete(TMP_DIR) }
    assert_raises(Errno::ENOENT) { Viking::Dir.delete("#{TMP_DIR}/does-not-exists") }

    assert Dir.exist?("#{TMP_DIR}/empty")
    assert 0 == Viking::Dir.delete("#{TMP_DIR}/empty")
    assert !Dir.exist?("#{TMP_DIR}/empty")
  end
end
