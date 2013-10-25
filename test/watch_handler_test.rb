require File.expand_path '../test_helper', __FILE__

class WatchHandlerTest < MiniTest::Test

	include DbHelpers

	def setup
		Ng2::HashDb.setup
		@file = File.expand_path("../sample1.notes.txt", __FILE__)
	end

	def teardown
		clear_watch_list
		Ng2::HashDb.teardown
	end

	def test_watch
		desc = ".watch should add given file to watch list"

		Ng2::WatchHandler.watch(@file)

		watch_list = fetch_watch_list
		assert watch_list.include?(@file), desc
	end

	def test_watch_2
		desc = ".watch should do nothing if the file is already present in watch list"

		Ng2::WatchHandler.watch(@file)
		Ng2::WatchHandler.watch(@file)  # adding second time
		count_for_file = fetch_watch_list.count{|list_item| list_item==@file}
		assert 1, count_for_file
	end

	def test_unwatch
		desc = ".unwatch should remove the given file from watch list"

		Ng2::WatchHandler.unwatch(@file)
		watch_list = fetch_watch_list
		assert_equal false, watch_list.include?(@file), desc
	end

	def test_list
		desc = ".list: should give the current watch list"

		Ng2::HashDb.set(Ng2::WatchHandler.watch_list_key, "/sample")
		list = Ng2::WatchHandler.list
		assert_equal ['/sample'], list, desc
	end

	def test_load
		skip
		
	end

	def test_save
		skip
		
	end

	def test_deserialize
		skip
		
	end

	def test_serialize
		skip
		
	end

	## Helpers

	def fetch_watch_list
		Ng2::HashDb.get(Ng2::WatchHandler.watch_list_key)
	end

	def clear_watch_list
		Ng2::HashDb.set(Ng2::WatchHandler.watch_list_key, "")
	end

	
end


# puts "---->"; p value