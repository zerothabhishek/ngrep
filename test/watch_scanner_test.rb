require File.expand_path '../test_helper', __FILE__
require 'fileutils'

class WatchScannerTest < MiniTest::Test

	def setup
    Ng2::HashDb.setup
    @dir = File.expand_path("..", __FILE__)
    @watch_scanner = Ng2::WatchScanner.new(@dir)    
	end

	def teardown
		Ng2::HashDb.teardown
	end

	def test_scan
		desc = '#scan traverses the given directory tree for notable files'

		dir = setup_sample_dir_tree
		watch_scanner = Ng2::WatchScanner.new(dir)
		notable_files = []
		watch_scanner.scan do |file|
			notable_files << File.basename(file)
		end
		assert_equal ['notes-l2.txt', 'notes-l1.txt', 'notes-l0.txt'], notable_files, desc	
		delete_sample_dir_tree
	end

	def test_notable
		desc = "#notable? gives true if the filename contains 'notes'"
		file_path = File.expand_path("../sample1.notes.txt", __FILE__)
		assert @watch_scanner.notable?(file_path), desc
	end

	def test_notable_2
		desc = "#notable? gives true if the file has extension txt or md"
		file_path1 = File.expand_path("../sample1.notes.md", __FILE__)
		assert @watch_scanner.notable?(file_path1), desc
	end

	def test_notable_3
		desc = "#notable? gives false if the file is not readable"
		file_path2 = File.expand_path("../does-not-exist.txt", __FILE__)
		assert_equal false, @watch_scanner.notable?(file_path2), desc
	end

	def test_prunable
		desc = "#prunable? gives true if its a hidden file"
		assert_equal true, @watch_scanner.prunable?("~/.ng2"), desc
	end

	def test_too_deep
		desc = "#too_deep? gives true if file is /code/l1/l2/l3/l4/l5/notes.txt and scan-root is /code"
		watch_scanner = Ng2::WatchScanner.new('/code')
		assert_equal true, watch_scanner.too_deep?("/code/l1/l2/l3/l4/notes.txt"), desc
	end

	def test_too_deep_2
		desc = "#too_deep? gives false if file is /code/l1/l2/l3/notes.txt and scan-root is /code"
		watch_scanner = Ng2::WatchScanner.new('/code')
		assert_equal false, watch_scanner.too_deep?("/code/l1/l2/l3/notes.txt"), desc
	end

	## Helpers
	def setup_sample_dir_tree
		sample_root = File.expand_path("../../tmp/sample-dir", __FILE__)
		FileUtils.mkdir_p sample_root
		FileUtils.mkdir_p File.join sample_root, 'l1'
		FileUtils.mkdir_p File.join sample_root, 'l1', 'l2'
		FileUtils.touch File.join sample_root, 'notes-l0.txt'
		FileUtils.touch File.join sample_root, 'l1', 'notes-l1.txt'
		FileUtils.touch File.join sample_root, 'l1', 'l2', 'notes-l2.txt'
		sample_root
	end

	def delete_sample_dir_tree
		sample_root = File.expand_path("../../tmp/sample-dir", __FILE__)
		FileUtils.rm_r(sample_root)
	end
	
end
