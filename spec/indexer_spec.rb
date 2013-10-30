require File.dirname(__FILE__) + '/spec_helper'

describe "Ngrep::Indexer" do

	describe "rehash" do

		before(:each) do
			flush_db 
			@file = File.expand_path("../sample.notes.md", __FILE__)
		end

		it "should build an index of words in the given file" do 
			lambda{
				Ngrep::Indexer.rehash(@file)
			}.should change(Ngrep::Index, :size)
		end

		it "should create an entry for 'word1' in index when it is present in the given file" do
			Ngrep::Indexer.rehash(@file)   ## sample.notes.md contains word1
			Ngrep::Index.find('word1').size.should be > 0
		end

		it "should set the word's line_number in the index" do 
			word = 'word1'               ## sample.notes.md contains word1 
			line_number = 3              ## at line 3  
			Ngrep::Indexer.rehash(@file)   
			Ngrep::Index.find('word1').last.line_number.should eq(3)
		end

		it "should set the word's date in the index"	do
			word = 'word1'                ## sample.notes.md contains word1
			date = '1may2013'             ## and its date is word 1may2013
			Ngrep::Indexer.rehash(@file)   
			Ngrep::Index.find('word1').last.date.should eq(Date.parse('1may2013'))
		end

		it "should set the file's project in the index" do 
			project = 'ngrep-proj'       ## since the file is /code/ngrep-proj/ngrep/spec/sample.note.md			
			Ngrep::Indexer.rehash(@file)   
			Ngrep::Index.find('word1').last.project.should eq('ngrep-proj')
		end										

		it "should set the file's path in the index" do
			Ngrep::Indexer.rehash(@file)   
			Ngrep::Index.find('word1').last.file_path.should eq(@file)		  
		end
	end

	describe "parse_date" do  

		it "should parse the date from the given date line" do
		  indexer = Ngrep::Indexer.new
		  line = "## 1may2013"
		  parsed_date = indexer.parse_date(line)
		  expected_date = Date.parse('1may2013')
		  parsed_date.should eq(expected_date)
		end

		it "should give nil when it is not a date line" do
		  indexer = Ngrep::Indexer.new
		  indexer.instance_variable_set(:@current_date, nil)
		  parsed_date = indexer.parse_date("notes1 notes2")
		  parsed_date.should be_nil
		end
	end

	describe "parse_project" do

		it "should be 'project1' when file path is '/code/project1/notes' " do
			indexer = Ngrep::Indexer.new
			parsed_project = indexer.parse_project('/code/project1/notes')
			parsed_project.should eq('project1')
		end

		it "should be 'project1' when file path is '/code/project1/project2/notes' " do
			indexer = Ngrep::Indexer.new
			parsed_project = indexer.parse_project('/code/project1/project2/notes')
			parsed_project.should eq('project1')
		end

		it "should be nil if there is no 'code' in the file path" do
			indexer = Ngrep::Indexer.new
			parsed_project = indexer.parse_project('/code1/project1/notes')
			parsed_project.should eq(nil)
		end

	end


end