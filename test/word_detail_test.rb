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

	def test_1
		desc = '.find: gives WordDetail list for given word from the db'

		empty_test_db
		Ng2::HashDb.add(@word, @details_str)
		Ng2::HashDb.add(@word, @details_str2)
		@result = Ng2::WordDetail.find('xerxes') 

		assert_kind_of Ng2::WordDetail, @result[0], desc
		assert_equal 2, @result.size, desc
	end	

	def test_2
		desc = '.build: gives a WordDetail object'
		result = Ng2::WordDetail.build @word, @details_str
		assert_kind_of Ng2::WordDetail, result, desc
	end

	def test_2a
		desc = '.build: gives a WordDetail with word as xerxes'
		result = Ng2::WordDetail.build @word, @details_str
		assert_equal 'xerxes', result.word, desc
	end

	def test_2b
		desc = '.build: gives a WordDetail with file_path as /action/300'
		result = Ng2::WordDetail.build @word, @details_str
		assert_equal '/action/300', result.file_path, desc		
	end

	def test_2c
		desc = '.build: gives a WordDetail with line_no as 20'
		result = Ng2::WordDetail.build @word, @details_str
		assert_equal '20', result.line_no, desc				
	end

	def test_2d
		desc = '.build: gives a WordDetail with word_no as 3'
		result = Ng2::WordDetail.build @word, @details_str
		assert_equal '3', result.word_no, desc
	end

	def test_3
		desc = '#duplicate? is true if another word exists in db with same details'
		empty_test_db
		Ng2::HashDb.add(@word, @details_str) 
		@result = @word_detail.duplicate?    
		assert_equal true, @result, desc
	end

	def test_3a
		desc = '#duplicate? is false if the same word does not exist in db'
		empty_test_db
		@result = @word_detail.duplicate? 
		assert_equal false, @result, desc		
	end

	def test_3b
		empty_test_db
		desc = '#duplicate? is false if the word exists in db but has different details'

		Ng2::HashDb.add(@word, @details_str2) 
		@result = @word_detail.duplicate?     
		assert_equal false, @result, desc
	end

	def test_4
		desc = '#save: stores the WordDetail to the db'
		empty_test_db
		@word_detail.save 
		@result = Ng2::HashDb.get(@word).nil? 
		assert_equal false, @result
	end

	def test_6
		desc = '#serialize'
		skip
	end

	def test_7
		desc = '#deserialize'
		skip
	end

	def empty_test_db
		Ng2::HashDb.db_scanner.clear
	end

	
end
