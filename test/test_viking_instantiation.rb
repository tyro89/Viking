require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/viking.rb', __FILE__)

java_import org.apache.hadoop.security.UserGroupInformation

class TestFileUtilsClassMethods < MiniTest::Unit::TestCase
	def test_no_impersonation
		client = Viking.client
		conf = client.getConf()
		assert conf.get("hadoop.job.ugi") == UserGroupInformation.getCurrentUser().getShortUserName()
	end

	def test_impersonate_foo_user
		Java::java.lang.System.setProperty("HADOOP_USER_NAME", "foo")
		client = Viking.client
		conf = client.getConf()
		assert conf.get("hadoop.job.ugi", "foo")
	end

end