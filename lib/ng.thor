##!/usr/bin/env ruby
require "thor"


## After changes to this file, run: thor update ng.thor

class Ng < Thor

	## thor ng find term
	desc "find TERM", "search the given term"
	option :pre, :type => :numeric, :aliases => :a
	option :post, :type => :numeric, :aliases => :b 
	def find(term)
		require '/Users/abhishekyadav/code/ngrep-proj/ngrep/application.rb'
		puts Ngrep::Search.find(term, options)
	end

	desc "rehash", "rebuild the index"
	def rehash
		#Ngrep::Build.new(filename: "/path/to/file").run
		require '/Users/abhishekyadav/code/ngrep-proj/ngrep/application.rb'
		Ngrep::Build.rehash
	end

	desc "watch FILE", "adds FILE to watch list"
	def watch(file)
		require '/Users/abhishekyadav/code/ngrep-proj/ngrep/application.rb'
		Ngrep::WatchList.add file
		puts "Added #{file} to watch list. Do rehash too"
	end

	desc "unwatch FILE", "removes file from watch list"
	option :all, :type => :boolean, :aliases => :a
	def unwatch(file)
		require '/Users/abhishekyadav/code/ngrep-proj/ngrep/application.rb'
		if options[:all]
			Ngrep::WatchList.clear
		else
			Ngrep::WatchList.remove file
			puts "Removed #{file} from watch list. Do rehash too"
		end		
	end

	desc "watchlist", "shows the watch list"
	def watchlist
		require '/Users/abhishekyadav/code/ngrep-proj/ngrep/application.rb'
		puts Ngrep::WatchList.show	
	end	

	desc "hi", "just loads the Ngrep application"
	def hi
		require '/Users/abhishekyadav/code/ngrep-proj/ngrep/application.rb'
	end

	#default_task :search ## doesn't work right
end

#Ng.start  # uncomment to make this a shell command

