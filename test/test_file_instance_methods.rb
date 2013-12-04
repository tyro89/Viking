require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/viking.rb', __FILE__)

class TestFileInstanceMethods < MiniTest::Unit::TestCase

  TMP_DIR          = "/tmp/viking"
  TEST_FILE_1      = "test_file_1.rb"
  TEST_FILE_2      = "test_file_2.rb"
  TEST_FILE_PATH_1 = "#{TMP_DIR}/#{TEST_FILE_1}"
  TEST_FILE_PATH_2 = "#{TMP_DIR}/#{TEST_FILE_2}"

  CONTENT = "line1\nline2\nline3\n"

  def setup
    FileUtils.mkpath(TMP_DIR) unless File.exists?(TMP_DIR)
    FileUtils.touch(TEST_FILE_PATH_2)
    File.write(TEST_FILE_PATH_2, CONTENT)
  end

  def teardown
    FileUtils.remove_dir(TMP_DIR) if File.exists?(TMP_DIR)
  end

  def file1
    Viking::File.new(TEST_FILE_PATH_1)
  end

  def file2
    Viking::File.new(TEST_FILE_PATH_2)
  end

  def test_path
    assert TEST_FILE_PATH_1 == file1.path
  end

  def test_size
    assert CONTENT.bytes.to_a.size == file2.size
  end

  def test_close
    f = file2
    assert !f.closed?

    f.close
    assert f.closed?
  end

  def test_each_line
    lines = []
    file2.each_line do |line|
      lines << line
    end
    assert CONTENT == lines.join("")
  end

  def test_each_char
    chars = []
    file2.each_char do |char|
      chars << char
    end
    assert chars == CONTENT.bytes.to_a
  end

  def test_eof
    f = file2
    assert !f.eof

    f.getc
    assert !f.eof

    f.read
    assert f.eof

    f.close
  end

  def test_eof?
    f = file2
    assert !f.eof?

    (CONTENT.bytes.to_a.size - 1).times { f.getc }
    assert !f.eof

    f.getc
    assert f.eof

    f.close
  end

  def test_getc
    f = file2
    assert CONTENT.bytes.first == f.getc
    f.close
  end

  def test_gets
    f = file2
    assert "#{CONTENT.split("\n").first}\n" == file2.gets("\n", nil)
    f.close

    f = file2
    assert CONTENT[0,10] == f.gets(nil, 10)
    f.close

    f = file2
    assert "#{CONTENT.split("\n").first}\n" == f.gets("\n", 10)
    f.close
  end

  def test_putc
    f = file1
    f.putc("a")
    f.close
    assert File.read(TEST_FILE_PATH_1) == "a"

    File.delete(TEST_FILE_PATH_1)

    f = file1
    f.putc("a".bytes.first)
    f.close
    assert File.read(TEST_FILE_PATH_1) == "a"
  end

  def test_puts
    f = file1
    f.puts("foo", "bar", "biz")
    f.close
    assert File.read(TEST_FILE_PATH_1) == "foo\nbar\nbiz\n"
  end

  def test_read
    assert CONTENT == file2.read
  end

  def test_write
    f = file1
    f.write("foobar")
    f.close
    assert File.read(TEST_FILE_PATH_1) == "foobar"
  end
end
