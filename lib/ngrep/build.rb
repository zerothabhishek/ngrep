#require 'active_support/time'

#load File.expand_path("../hash.rb", __FILE__)

module Ngrep
	class Build

		attr_reader :current_project, :current_date, :storage

		def self.rehash(watch_list)
			Ngrep::Word.all.map(&:destroy)
			watch_list.each do |watched_file|
				begin
					watched_file.chomp!
					Ngrep::Build.new(filename: watched_file).run
					puts "rehashed #{watched_file}"
				rescue => e
					puts "rehash failed for #{watched_file}: #{e}"
				end
			end
		end

		def self.rehash2
			Ngrep::Hash.new.clear
			watch_list = Ngrep::WatchList.new
			watch_list.load
			watch_list.list.each do |watched_file|
				watched_file.chomp!
				begin
					Ngrep::Build.new(filename: watched_file).run 
					puts "rehashed #{watched_file}"
				rescue => e
					puts "rehash failed for #{watched_file}: #{e}"
				end
			end
		end

		def initialize(args)
			@filename = args[:filename] 
			@current_date = ""
			@current_project = nil
			@storage = nil
		end

		def run
			#load_storage
			parse_project
			File.open(@filename).readlines.each_with_index do |line, i|
				parse_date(line)
				words = get_words(line)
				words.each do |word|
					#@storage.push(word, {
					#	line_number: i,
					#	date: @current_date,
					#	project: @current_project,
					#	file_path: @filename
					#})
					Word.create(
						value: word, 
						line_number: i+1, 
						date: @current_date, 
						project: @current_project,
						file_path: @filename )
				end
			end
			#finalize
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
			project_str=nil
			@filename.match(/\/code\/(.+)\//) do |matches|
				if matches[1]
					project_str = matches[1].split("/").first
				end
			end
			@current_project = project_str
		end
		
		
	end
end

## Ngrep::Build.new(filename: "/path/to/file").run


