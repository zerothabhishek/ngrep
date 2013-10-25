require File.expand_path '../test_helper', __FILE__

class HashDbTest2 < MiniTest::Test

	include DbHelpers

	def setup
		empty_test_db
		@key = "sample-key"
		@value = "sample-value"
		@existing_value = "existing-value"
	end

	def test_1
		desc = "#set: should set the given key value"
		Ng2::HashDb.new(test_db_path).set(@key, @value)
		assert_equal @value, db_get(@key), desc
	end

	def test_2
		desc = "#get: should get the asked key value"
		db_set(@key, @value)
		assert_equal @value, Ng2::HashDb.new(test_db_path).get(@key), desc
	end

	def test_3
		desc = ".add: should append the new value if key pre-exists"
		db_set(@key, @existing_value)
		Ng2::HashDb.add(@key, @value)
		expected_value = "#{@existing_value}|#{@value}"
		assert_equal expected_value, db_get(@key), desc
	end

	def test_4
		desc = ".add: should just the new value if key doesn't pre-exist"
		Ng2::HashDb.add(@key, @value)
		assert_equal @value, db_get(@key), desc
	end

	def test_5
		desc = ".get: gives a list of values at a key"
		db_set(@key, 'v1|v2|v3')
		expected_value = ['v1', 'v2', 'v3']
		assert_equal expected_value, Ng2::HashDb.get(@key), desc
	end

	def test_6
		desc = ".get: gives an empty array if key doesn't exist"
		assert_equal [], Ng2::HashDb.get(@key), desc
	end

end