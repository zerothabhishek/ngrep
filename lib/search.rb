#require 'json'

module Ngrep
	class Search

		def data_file
			Ngrep::Config[:data_file]
		end

		def initialize
			
		end

		def run(term)
			load_index
			@index[term]
		end

		def load_index
			@index = JSON.parse File.read data_file
		end

		def find(term, options)
			pre = options[:pre].to_i
			post = options[:post].to_i
			results = self.run(term) || []
			results.map{|r| result_string(r, pre, post) }.join("\n")
		end

		def result_string(r, pre, post)
			str = ""
			str += "*** "                ## each result starts with this symbol
			str += result_project(r)     ## first the project name
			str += ", "                  ## comma after the project name
			str += result_date(r)        ## then the result date
			str += ". "                  ## comma after result date
			str += result_line_no(r)                      ## then the line no. 
			str += pre==0 && post==0 ? ": " : ": \n"      ## line break if pre/post lines are needed
			str += result_lines(r, pre, post)             ## and the result lines, with pre/post lines
			str                                   
		end

		def result_project(result)
			result["project"].to_s
		end

		def result_date(result)
			result["date"].to_s
		end

		def result_line_no(result)
			result["line_number"].to_s
		end

		def result_lines(result, pre=0, post=0)
			file_path = result["file_path"]
			line_no   = result["line_number"]
			lines_from_file(file_path, line_no, pre, post).map do |line|
				line.gsub("\n", '')  ## remove the line-break at the end
			end.join("\n")
		end

		def lines_from_file(file_path, line_no, pre, post)
			f = File.open(file_path, "r")
			(line_no-pre).times{ f.gets }
			num = pre + post + 1
			lines = (1..num).map { f.gets }
			f.close
			lines
		end

		def self.find(term, options={})
			Ngrep::Search.new.find(term, options)
		end

	end	
end


## search = Ngrep::Search.new
## search.run("note-1")