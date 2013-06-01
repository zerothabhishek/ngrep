#require 'json'

module Ngrep
	class Hash

		#DataFile = "/Users/abhishekyadav/code/ngrep-proj/ngrep/data/hash.json"

		attr_reader :hash

		def initialize(args=nil)
			@hash = {}
		end

		def data_file
			Ngrep::Config[:data_file]
		end
		
		def load
			unless File.exists?(data_file)
				File.open(data_file,"w") do |f|
					f.write "{}"
				end
			end
			@hash = JSON.parse File.read data_file
		end

		def save
			File.write(data_file, JSON.dump(@hash))
		end

		def push(key, value)
			@hash[key] = [] unless @hash[key]
			@hash[key].push value
		end
		
	end
end

## Ngrep::Hash
##
## example:
##
## word = "new-relic"
## meta = {:date=>"2013-05-02 00:00:00 +0530", :line_number=>20, :project=>"engrave-proj", :file_path=>"/Users/abhishekyadav/code/ngrep-proj/ngrep/data/sample.notes.md"}
##
## storage = Ngrep::Hash.new
## storage.load
## storage.push(word, meta)
## storage.save
##