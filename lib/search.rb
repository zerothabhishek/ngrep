require 'json'

module Ngrep
	class Search

		#DataFile = "/Users/abhishekyadav/code/ngrep-proj/ngrep/data/hash.json"
		def data_file
			"/Users/abhishekyadav/code/ngrep-proj/ngrep/data/hash.json"
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

	end	
end


## search = Ngrep::Search.new
## search.run("note-1")