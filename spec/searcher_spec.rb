require File.dirname(__FILE__) + '/spec_helper'

describe Ngrep::Searcher do	

	describe "find" do

		before(:each) do
			flush_db
		end

		def sample_index_entry
			{ value: 'word1', project: 'lebowsky', line_number: 22, date: '1may2013', file_path: '/tmp/code/lebowsky/notes'}
		end

		def build_sample_file(dir, name, contents)
			file_path = File.join(dir, name)
			FileUtils.mkdir_p(dir)
			File.write(file_path, contents)
			file_path
		end

		def build_sample_index
			Ngrep::Indexer.rehash(sample_index_entry[:file_path])
		end

		it "should include 'lebowsky' in result when searched for 'bowling" do
			contents = "\n"*21 + %Q{F it Donny, Lets go bowling}
			file_path = build_sample_file('/tmp/code/lebowsky', 'notes', contents)
			Ngrep::Indexer.rehash(file_path)

		  result = Ngrep::Searcher.find('bowling')
		  result.should include 'lebowsky'
		end

		it "should include 22 as line-number in result when searched for 'bowling'" do
			contents = "\n"*21 + %Q{F it Donny, Lets go bowling}
			file_path = build_sample_file('/tmp/code/lebowsky', 'notes', contents)
			Ngrep::Indexer.rehash(file_path)

		  result = Ngrep::Searcher.find('bowling')
		  result.should include '22'		  
		end

		it "should include the line 'F it Donny, Lets go bowling' in result when searched for 'bowling'" do
			contents = %Q{F it Donny, Lets go bowling}
			file_path = build_sample_file('/tmp/code/lebowsky', 'notes', contents)
			Ngrep::Indexer.rehash(file_path)

		  result = Ngrep::Searcher.find('bowling')
		  puts result
		  result.should include 'F it Donny, Lets go bowling'		  		  
		end

		it "should give three lines of result for given 'bowling' given there are three entries for 'bowling' in the index" do
			contents = %Q{ 	
				F it Donny, Lets go bowling
				bowling is good for you lebowsky
				there is no more bowling here
			}
			file_path = build_sample_file('/tmp/code/lebowsky', 'notes', contents)
			Ngrep::Indexer.rehash(file_path)

		  results = Ngrep::Searcher.find('bowling')
		  results.split("\n").size.should eq(3)
		end

		it "should include the previous line 'Wassup Donny' along the result line when searched with the options pre:1" do
			contents = %Q{
				Wassup Donny
				F it Donny, Lets go bowling 
			}
			file_path = build_sample_file('/tmp/code/lebowsky', 'notes', contents)
			Ngrep::Indexer.rehash(file_path)

			results = Ngrep::Searcher.find('bowling', pre:1)
			results.should include('Wassup Donny')
		end

	end
end
