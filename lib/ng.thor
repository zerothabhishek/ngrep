##!/usr/bin/env ruby
require "thor"


## After changes to this file, run: thor update ng.thor

class Ng < Thor

	## thor ng find term
	desc "find TERM", "search the given term"
	option :pre, :type => :numeric, :aliases => :a
	option :post, :type => :numeric, :aliases => :b 
	def find(term)
		puts "loading..."; t0=Time.new
		require '/Users/abhishekyadav/code/ngrep-proj/ngrep/application.rb'
		t1=Time.now; puts "loaded in #{t1-t0} time"
		puts "searching..."
		puts Ngrep::Search.find(term, options)
	end

	desc "rehash", "rebuild the index"
	def rehash
		#Ngrep::Build.new(filename: "/path/to/file").run
		Ngrep::Build.rehash
	end

	desc "watch FILE", "adds FILE to watch list"
	def watch(file)
		Ngrep::WatchList.add file
		puts "Added #{file} to watch list. Do rehash too"
	end

	desc "unwatch FILE", "removes file from watch list"
	option :all, :type => :boolean, :aliases => :a
	def unwatch(file)
		if options[:all]
			Ngrep::WatchList.clear
		else
			Ngrep::WatchList.remove file
			puts "Removed #{file} from watch list. Do rehash too"
		end		
	end

	desc "watchlist", "shows the watch list"
	def watchlist
		puts Ngrep::WatchList.show	
	end	

	#default_task :search ## doesn't work right
end

#Ng.start  # uncomment to make this a shell command

