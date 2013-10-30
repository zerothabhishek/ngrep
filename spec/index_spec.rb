require File.dirname(__FILE__) + '/spec_helper'

describe "Ngrep::Index" do

	before(:each) do
		flush_db 
	end
  
	describe "add" do

		it "adds the given 'word1' to the index" do
		  Ngrep::Index.add('word1')
		  Ngrep::Word.exists?(value: 'word1').should be_true
		end

		it "adds the given 'word1' with line_number 3 to the index" do
		  Ngrep::Index.add('word1', line_number: 3)
		  Ngrep::Word.exists?(value: 'word1', line_number: 3 ).should be_true
		end

		it "adds the given 'word1' with line_number 3 and date 1may2013 to the index " do
		  Ngrep::Index.add('word1', line_number: 3, date: '1may2013')
		  Ngrep::Word.exists?(value: 'word1', 
		  	line_number: 3, 
		  	date: Date.parse('1may2013') 
		  	).should be_true		  
		end

		it "adds the given 'word1' with line_number 3, date 1may2013 and project 'project1' to the index " do
		  Ngrep::Index.add('word1', line_number: 3, date: '1may2013', project: 'project1')
		  Ngrep::Word.exists?(value: 'word1', 
		  	line_number: 3, 
		  	date: Date.parse('1may2013'),
		  	project: 'project1'
		  	).should be_true		  		  
		end

		it "adds the given 'word1' with line_number 3, date 1may2013, project 'project1' and file_path '/code/p1' to the index " do
		  Ngrep::Index.add('word1', line_number: 3, date: '1may2013', project: 'project1', file_path: '/code/p1')
		  Ngrep::Word.exists?(value: 'word1', 
		  	line_number: 3, 
		  	date: Date.parse('1may2013'),
		  	project: 'project1',
		  	file_path: '/code/p1'
		  	).should be_true		  		  		  
		end

	end

	describe "find" do
		
		it "should give three results for 'word1' given there are three Word records in index with value 'word1'" do
			3.times{ Ngrep::Word.create(value: 'word1')}		  
			Ngrep::Index.find('word1').size.should eq(3)
		end

		it "should give two records for 'word1', :line_number=>3 given there are two records in index with value 'word1' and line_number as 3" do
			Ngrep::Word.create(value: 'word1', line_number: 4)
		  2.times{ Ngrep::Word.create(value: 'word1', line_number: 3)}
		  Ngrep::Index.find('word1', :line_number => 3).size.should eq(2)
		end

		it "should give two records for 'word1', :project => 'project1' given there are two records index with value 'word1' and project 'project1'" do
			Ngrep::Word.create(value: 'word1', project: 'project2')
		  2.times{ Ngrep::Word.create(value: 'word1', project: 'project1')}
		  Ngrep::Index.find('word1', :project => 'project1').size.should eq(2)			
		end

		it "should give two records for 'word1', :file_path=>'/code/pr1' given there are two records in index with value 'word1' and file path '/code/pr1' " do
			Ngrep::Word.create(value: 'word1', file_path: '/code/pr2')
		  2.times{ Ngrep::Word.create(value: 'word1', file_path: '/code/pr1')}
		  Ngrep::Index.find('word1', :file_path => '/code/pr1').size.should eq(2)			
		end

		it "should give two records for 'word1', :date => '1may2013' given there are two records in index with that value and date" do
		  Ngrep::Word.create(value: 'word1', date: '1may2012')
		  2.times{ Ngrep::Word.create(value: 'word1', date: '1may2013')}
		  Ngrep::Index.find('word1', :date => Date.parse('1may2013')).size.should eq(2)					  
		end
	end

	describe "size" do
		
		it "should give 10 when there are 10 records in the index" do
			10.times{ Ngrep::Word.create(value: 'word1') }
			Ngrep::Index.size.should eq(10)
		end
	end

	describe "install" do
		
	end

end