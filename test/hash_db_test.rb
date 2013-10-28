require File.expand_path '../test_helper', __FILE__

class HashDbTest < MiniTest::Test

	#include DbHelpers

	def setup
		set_scanner
		empty_test_db
	end

	def teardown
		close_scanner
	end

	def test_add
		desc = '.add should add a given value to the db'

		Ng2::HashDb.add("sample-key", "sample-value")
		assert_equal "sample-value", db_lookup("sample-key"), desc
	end

	def test_add_1
		desc = '.add should append if the value already exists'

		Ng2::HashDb.add('sample-key', 'existing-value')
		Ng2::HashDb.add('sample-key', 'sample-value')
		assert_equal 'existing-value|sample-value', db_lookup('sample-key'), desc
	end

	def test_get
		desc = '.get gets a list of values at the key (single-value)'

		Ng2::HashDb.add('sample-key', 'sample-value')
		assert_equal ['sample-value'], Ng2::HashDb.get('sample-key'), desc
	end

	def test_get_1
		desc = '.get gets a list of values at the key (two values)'

		Ng2::HashDb.add('sample-key', 'existing-value')
		Ng2::HashDb.add('sample-key', 'sample-value')
		assert_equal ['existing-value', 'sample-value'], Ng2::HashDb.get('sample-key'), desc
	end

	def test_get_2
		desc = '.get gets a list of values at the key (no-value)'
		assert_equal [], Ng2::HashDb.get('sample-key'), desc
	end

	def test_set
		desc = '.set sets the given value to the db'

		Ng2::HashDb.set('sample-key', 'sample-value')
		assert_equal 'sample-value', db_lookup('sample-key'), desc
	end

	def test_set_1
		desc = '.set overwrites if the value exists'

		Ng2::HashDb.set('sample-key', 'existing-value')
		Ng2::HashDb.set('sample-key', 'sample-value')
		assert_equal ['sample-value'], Ng2::HashDb.get('sample-key'), desc
	end

	def test_clear
		desc = '.clear deletes everything from the db'

		Ng2::HashDb.clear
		h={}; @scanner.each_pair{|k,v| h[k]=v}
		assert h.empty?, desc
	end

	def test_concat
		desc = ".concat adds the new value to the existing-values list"

		existing_values = ['existing-value']
		result = Ng2::HashDb.concat(existing_values, 'new-value')
		assert_equal 'existing-value|new-value', result
	end

	# Helpers
	def set_scanner
		db_file = File.expand_path('../../tmp/hash.kch', __FILE__)
		@scanner = KyotoCabinet::DB.new
		@scanner.open(db_file, KyotoCabinet::DB::OWRITER | KyotoCabinet::DB::OCREATE)
		Ng2::HashDb.db_scanner=@scanner
	end

	def close_scanner
		@scanner.close
	end

	def empty_test_db
		@scanner.clear
	end

	def db_lookup(key)
		@scanner.get(key)
	end

end


# separate class for tests where setup/teardown rules are different
class HashDbTest2 < MiniTest::Test  

	def test_open_scanner
		desc = ".open_scanner opens the db-file in write/create mode"

		Ng2::HashDb.db_file = "/tmp/sample.kch"
		Ng2::HashDb.open_scanner
		assert Ng2::HashDb.db_scanner, desc
	end

	def test_open_scanner_2
		desc = ".open_scanner throws exception if there's an error in opening the db"

		begin 
			Ng2::HashDb.db_file = nil
			Ng2::HashDb.open_scanner
		rescue RuntimeError => e
			assert_equal "Can't open the KC db", e.message, desc
		end
	end

	def test_setup
		desc = ".setup sets the db_file"

		Ng2::HashDb.setup
		assert Ng2::HashDb.db_file, desc
	end

	def test_setup_2
		desc = ".setup opens the scanner"
		Ng2::HashDb.setup
		assert Ng2::HashDb.db_scanner, desc
	end

	def test_teardown
		desc = ".teardown closes the open scanner"
		Ng2::HashDb.setup
		Ng2::HashDb.teardown
		assert_equal nil, Ng2::HashDb.db_scanner, desc
	end

	def test_setup_searcher
		desc = ".setup_searcher opens the db in read mode"

		Ng2::HashDb.db_file = "/tmp/sample.kch"
		Ng2::HashDb.setup_searcher
		assert Ng2::HashDb.db_searcher, desc
	end

	def test_setup_seacher_2
		desc = ".setup_searcher throws exception if opening the db fails"

		begin
			Ng2::HashDb.db_file = nil
			Ng2::HashDb.setup_searcher
		rescue RuntimeError => e
			assert_equal "Can't open the KC db", e.message, desc
		end
	end

	def test_teardown_searcher
		desc = ".teardown_searcher closes the open searcher"
		Ng2::HashDb.setup_searcher
		Ng2::HashDb.teardown_searcher
		assert_equal nil, Ng2::HashDb.db_searcher, desc
	end

end