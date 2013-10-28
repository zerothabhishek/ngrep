require File.expand_path '../test_helper', __FILE__

class WordDetailExtracterTest < MiniTest::Test

	def setup
		@sample_file = File.expand_path '../sample1.notes.txt', __FILE__
		@line = "Madness, this is Sparta"
		@file_path = "/code/sample-proj/my/sample/notes"
	end

	def test_1
		desc = "#from_file: should give a list of WordDetail objects"

		word_details = Ng2::WordDetailExtracter.new.from_file(@sample_file)
		assert word_details.size>0
		assert_kind_of Ng2::WordDetail, word_details[0], desc
	end

	def test_2
		desc = "#from_file: should give a WordDetail for 'madness'"

		word_details = Ng2::WordDetailExtracter.new.from_file(@sample_file)
		assert word_details.any?{|word_detail| word_detail.word=="madness"}, desc
	end

	def test_3
		desc = "#from_line: should give WordDetail objects for given line"

		word_details = Ng2::WordDetailExtracter.new.from_line(@line)
		assert_equal 'madness',  word_details[0].word, desc
		assert_equal 'this',     word_details[1].word, desc
		assert_equal 'is',       word_details[2].word, desc
		assert_equal 'sparta',   word_details[3].word, desc
	end

	def test_4
		desc = "#from_line: should give WordDetail objects with word_no"

		word_details = Ng2::WordDetailExtracter.new.from_line(@line)
		assert_equal 0, word_details[0].word_no, desc
		assert_equal 1, word_details[1].word_no, desc
		assert_equal 2, word_details[2].word_no, desc
		assert_equal 3, word_details[3].word_no, desc
	end

	def test_5
		desc = "#from_line: should give WordDetail objects with line_no"

		word_details = Ng2::WordDetailExtracter.new.from_line(@line, line_no: 20)
		assert_equal 20, word_details[0].line_no, desc
		assert_equal 20, word_details[1].line_no, desc
		assert_equal 20, word_details[2].line_no, desc
		assert_equal 20, word_details[3].line_no, desc
	end

	def test_6
		desc = "#from_line: should give WordDetail objects with file_path"
		
		word_details = Ng2::WordDetailExtracter.new.from_line(@line, file_path: @file_path)
		assert_equal @file_path, word_details[0].file_path, desc
		assert_equal @file_path, word_details[1].file_path, desc
		assert_equal @file_path, word_details[2].file_path, desc
		assert_equal @file_path, word_details[3].file_path, desc
	end

	def test_7
		desc = "#parse_words: should get a list of words in the line"

		words = Ng2::WordDetailExtracter.new.parse_words(@line)
		assert_equal ["Madness", "this", "is", "Sparta"], words, desc
	end

	def test_8		
		desc = "#remove_punctuations: should remove punctuation marks if present at last character"

		word = "Hello,"
		assert_equal "Hello", Ng2::WordDetailExtracter.new.remove_punctuations(word), desc
	end
end

