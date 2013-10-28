require File.expand_path '../test_helper', __FILE__

class WordDetailTest < MiniTest::Test

	def setup
		Ng2::HashDb.setup
		@word = 'xerxes'
		@details_str = '/action/300,20,3'
		@details_str2 = '/action/300,25,1'
		@word_detail = Ng2::WordDetail.new(@word, 
			file_path: '/action/300', line_no: '20', word_no: '3')
		@result = nil
	end

	def teardown
		Ng2::HashDb.teardown
	end

	def test_find
		desc = '.find: gives WordDetail list for given word from the db'

		empty_test_db
		Ng2::HashDb.add(@word, @details_str)
		Ng2::HashDb.add(@word, @details_str2)
		@result = Ng2::WordDetail.find('xerxes') 

		assert_kind_of Ng2::WordDetail, @result[0], desc
		assert_equal 2, @result.size, desc
	end	

	def test_build
		desc = '.build: gives a WordDetail object'
		result = Ng2::WordDetail.build @word, @details_str
		assert_kind_of Ng2::WordDetail, result, desc
	end

	def test_build_2
		desc = '.build: gives a WordDetail with word as xerxes'
		result = Ng2::WordDetail.build @word, @details_str
		assert_equal 'xerxes', result.word, desc
	end

	def test_build_3
		desc = '.build: gives a WordDetail with file_path as /action/300'
		result = Ng2::WordDetail.build @word, @details_str
		assert_equal '/action/300', result.file_path, desc		
	end

	def test_build_4
		desc = '.build: gives a WordDetail with line_no as 20'
		result = Ng2::WordDetail.build @word, @details_str
		assert_equal '20', result.line_no, desc				
	end

	def test_build_5
		desc = '.build: gives a WordDetail with word_no as 3'
		result = Ng2::WordDetail.build @word, @details_str
		assert_equal '3', result.word_no, desc
	end

	def test_duplicate
		desc = '#duplicate? is true if another word exists in db with same details'
		empty_test_db
		Ng2::HashDb.add(@word, @details_str) 
		@result = @word_detail.duplicate?    
		assert_equal true, @result, desc
	end

	def test_duplicate_2
		desc = '#duplicate? is false if the same word does not exist in db'
		empty_test_db
		@result = @word_detail.duplicate? 
		assert_equal false, @result, desc		
	end

	def test_duplicate_3
		empty_test_db
		desc = '#duplicate? is false if the word exists in db but has different details'

		Ng2::HashDb.add(@word, @details_str2) 
		@result = @word_detail.duplicate?     
		assert_equal false, @result, desc
	end

	def test_save
		desc = '#save: stores the WordDetail to the db'
		empty_test_db
		@word_detail.save 
		@result = Ng2::HashDb.get(@word).nil? 
		assert_equal false, @result
	end

	def test_serialize
		desc = '#serialize'
		skip
	end

	def test_deserialize
		desc = '#deserialize'
		skip
	end

	def empty_test_db
		Ng2::HashDb.db_scanner.clear
	end

end

class WordDetailTest2 < MiniTest::Test  # for tests where setup-teardown is different

	def setup
		@sample_file = File.expand_path '~/code/ngrep-proj/ng2/test/sample1.notes.txt'
		@word_detail = Ng2::WordDetail.new('leonidas',
			file_path: @sample_file, line_no: 1, word_no: 3)
	end

	def test_build_result
		assert_equal( 
			'~/code/ngrep-proj/ng2/test/sample1.notes.txt:1:-> this is Sparta leonidas', 
			@word_detail.build_result)
	end	

	def test_build_header
		assert_equal(
		  '~/code/ngrep-proj/ng2/test/sample1.notes.txt:1',
		  @word_detail.build_header)
	end

	def test_header_end
		desc = '#header_end has a line break if pre/post options are specified'
		assert_equal ":\n ", @word_detail.header_end(pre:1, post:1)
	end

	def test_header_end_2
		desc = '#header_end has no line break if there are no pre/post options'
		assert_equal ":", @word_detail.header_end
	end

	def test_lines_from_file
		desc = '#lines_from_file gives the line from the word_detail: file_path/line_no'
		this_line = 'this is Sparta leonidas' + "\n"
		assert_equal [this_line], @word_detail.lines_from_file
	end
	
	def test_lines_from_file_2
		desc = '#lines_from_file should give the previous one line too when pre is 1'

		prev_line = 'Madness' + "\n"
		this_line = 'this is Sparta leonidas' + "\n"
		assert_equal [prev_line, this_line], @word_detail.lines_from_file(pre: 1)
	end

	def test_lines_from_file_3
		desc = '#lines_from_file should give the next line too when post is 1'

		this_line = 'this is Sparta leonidas' + "\n"
		next_line = 'no this was not sparta' + "\n"
		assert_equal [this_line, next_line], @word_detail.lines_from_file(post: 1)
	end

	def test_lines_from_file_4
		desc = '#lines_from_file should give the prev and next lines too when pre is 1 and post is 1'

		prev_line = 'Madness' + "\n"
		this_line = 'this is Sparta leonidas' + "\n"
		next_line = 'no this was not sparta' + "\n"
		assert_equal( 
			[prev_line, this_line, next_line], 
			@word_detail.lines_from_file(pre:1, post: 1))
	end
end
