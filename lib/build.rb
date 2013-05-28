require 'active_support/time'

load File.expand_path("../hash.rb", __FILE__)

module Ngrep
	class Build

		attr_reader :current_project, :current_date, :storage

		def initialize(args)
			@filename = args[:filename] 
			@current_date = ""
			@current_project = ""
			@storage = nil
		end

		def run
			load_storage
			parse_project
			File.open(@filename).readlines.each_with_index do |line, i|
				parse_date(line)
				words = get_words(line)
				words.each do |word|
					@storage.push(word, {
						line_number: i,
						date: @current_date,
						project: @current_project,
						file_path: @filename
					})
				end
			end
			finalize
		end

		def load_storage
			@storage = Ngrep::Hash.new
			@storage.load
		end

		def finalize
			@storage.save			
		end

		def get_words(line)
			line.split(/\s/)
		end

		def parse_date(line)
			line.match(/## (.+)/) do |matches|
				date = Date.parse(matches[1]) rescue nil
				@current_date = date if date
			end
		end

		def parse_project
			@filename.match(/\/code\/(.+)\//) do |matches|
				if matches[1]
					@current_project = matches[1].split("/").first
				end
			end
		end
		
		
	end
end

## Ngrep::Build.new(filename: "/path/to/file").run


