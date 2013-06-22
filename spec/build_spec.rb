require File.dirname(__FILE__) + '/spec_helper'

describe "Ngrep::Build" do

	before(:each) do
		flush_db 
		@file = File.expand_path("../sample.notes.md", __FILE__)
	end

	describe "run" do
		
		it "should build an index of words in the given file" do 
			lambda{
				Ngrep::Build.new(filename: @file).run
			}.should change(Ngrep::Word, :count)
		end

		it "should include the word's line-number in the index" do
			word_str, line_number = 'word1', 3        # from sample.notes.md
			Ngrep::Build.new(filename: @file).run
			Ngrep::Word.where(value: word_str).pluck(:line_number).should eq([3])
		end

		it "should include the word's projectname in the index" do 
			word_str, project_name = 'word1', 'ngrep-proj'
			Ngrep::Build.new(filename: @file).run
			Ngrep::Word.where(value: word_str).pluck(:project).should eq(['ngrep-proj'])
		end

		it "should include the word's date in the index" do 
			word_str, date = 'word1', '1may2013'
			Ngrep::Build.new(filename: @file).run
			date_stored = Ngrep::Word.where(value: word_str).pluck(:date).last
			date_stored.strftime("%-d%b%Y").downcase.should eq('1may2013')
		end

		it "should include the word's file path in the index" do 
			word_str, file_path = 'word1', @file
			Ngrep::Build.new(filename: @file).run
			Ngrep::Word.where(value: word_str).pluck(:file_path).should eq([file_path])
		end


	end

	describe "parse_date" do  

		it "should parse the date from the given date line" do
		  builder = Ngrep::Build.new(filename: @file)
		  line = "## 1may2013"
		  builder.parse_date(line)
		  parsed_date = builder.current_date
		  expected_date = Date.parse('1may2013')
		  parsed_date.should eq(expected_date)
		end

		it "should not change current_date when it is not a date line" do
		  builder = Ngrep::Build.new(filename: @file)
		  line = "notes1 notes2"		  
		  builder.instance_variable_set(:@current_date, nil)
		  builder.parse_date(line)
		  builder.current_date.should eq(nil)		  
		end
	end

	describe "parse_project" do

		it "should be 'project1' when file path is '/code/project1/notes' " do
			file = '/code/project1/notes'
		  builder = Ngrep::Build.new(filename: file)
		  builder.parse_project
		  builder.current_project.should eq('project1')
		end

		it "should be 'project1' when file path is '/code/project1/project2/notes' " do
			file = '/code/project1/project2/notes'
		  builder = Ngrep::Build.new(filename: file)
		  builder.parse_project
		  builder.current_project.should eq('project1')		  
		end

		it "should be nil if there is no 'code' in the file path" do
			file = '/code1/project1/notes'
		  builder = Ngrep::Build.new(filename: file)
		  builder.parse_project
		  builder.current_project.should eq(nil)		  		  
		end

	end



	describe "rehash" do 
		

		it "should delete the index when watch list is empty" do
		 	Ngrep::Build.new(filename: @file).run ## build existing index
		 	lambda { 
		 		watch_list = []
		 		Ngrep::Build.rehash(watch_list)
		 	}.should change(Ngrep::Word, :count).to(0)
		end

		it "should build index from files in the watch list" do
		  lambda{
		  	watch_list = build_watch_list %w(file1 file2 file3)
		  	Ngrep::Build.rehash(watch_list)
		  }.should change(Ngrep::Word, :count).by_at_least(1)
		end

		it "should make sure index contains an entry for word 'notes1' if a file in watch list contains it" do
			watch_list = build_watch_list %w(file1 file2 file3)
			File.write("a", watch_list[0]) do |f|
				f.write("notes1")
			end
			Ngrep::Build.rehash(watch_list)
			Ngrep::Word.exists?(value: "notes1").should be_true
		end

	end


end