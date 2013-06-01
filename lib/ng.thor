##!/usr/bin/env ruby
require "thor"


## After changes to this file, run: thor update ng.thor

class Ng < Thor

	desc "find TERM", "search the given term"
	option :pre, :type => :numeric, :aliases => :a
	option :post, :type => :numeric, :aliases => :b 
	def find(term)
		require '/Users/abhishekyadav/code/ngrep-proj/ngrep/ngrep.rb'
		puts Ngrep::Search.find(term, options)
	end

	desc "rehash", "rebuild the index"
	def rehash
		Ngrep::Build.new(filename: "/path/to/file").run
	end

	desc "add FILE", "adds file to watch list"
	def add(file)
		puts "adding #{file}"
	end

	desc "remove FILE", "removes file from watch list"
	def remove(file)
		puts "removing #{file}"
	end

	#default_task :search ## doesn't work right
end

#Ng.start  # uncomment to make this a shell command

