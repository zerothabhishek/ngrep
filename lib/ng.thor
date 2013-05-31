##!/usr/bin/env ruby
require "thor"

class Ng < Thor

	desc "find TERM", "search the given term"
	def find(term)
		require "/Users/abhishekyadav/code/ngrep-proj/ngrep/lib/search.rb"
		search = Ngrep::Search.new
		results = search.run(term)
		results.each do |result|
			puts result["project"].to_s + ": " + result["date"] 
		end
	end

	desc "rehash", "rebuild the index"
	def rehash
		puts "rebuilding the index"
	end

	#default_task :search ## doesn't work right
end

#Ng.start