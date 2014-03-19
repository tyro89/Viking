require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/viking.rb', __FILE__)

class TestDirInstanceMethods < MiniTest::Unit::TestCase

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

  def test_close
    d = Viking::Dir.new(TMP_DIR)
    d.read
    d.close
    assert_raises(IOError) { d.read }
    assert_raises(IOError) { d.close }
  end

  def test_each
    d = Viking::Dir.new(TMP_DIR)

    entries = []
    d.each do |entry|
      entries << entry
    end

    assert [TEST_FILE_1, TEST_FILE_2].sort == entries.sort
  end

  def test_path
    d = Viking::Dir.new(TMP_DIR)
    assert TMP_DIR == d.path
  end

  def test_read
    d = Viking::Dir.new(TMP_DIR)

    assert [TEST_FILE_1, TEST_FILE_2].sort == [d.read, d.read].sort
    assert d.read.nil?
    assert d.read.nil?
  end

  def test_rewind
    d = Viking::Dir.new(TMP_DIR)

    assert [TEST_FILE_1, TEST_FILE_2].sort == [d.read, d.read].sort
    assert d.read.nil?
    assert d.read.nil?

    d.rewind

    assert [TEST_FILE_1, TEST_FILE_2].sort == [d.read, d.read].sort
    assert d.read.nil?
    assert d.read.nil?
  end
end
