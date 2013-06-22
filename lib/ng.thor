##!/usr/bin/env ruby
require "thor"


## After changes to this file, run: thor update ng.thor

class Ng < Thor

	## thor ng find term
	desc "find TERM", "search the given term"
	option :pre, :type => :numeric, :aliases => :a
	option :post, :type => :numeric, :aliases => :b 
	def find(term)
		require 'ngrep'
		Ngrep::Db.connect
		puts Ngrep::Search.find(term, options)
	end

	desc "rehash", "rebuild the index"
	def rehash
		require 'ngrep'
		Ngrep::Db.connect
		watch_list = Ngrep::WatchList.load
		Ngrep::Build.rehash(watch_list)
	end

	desc "watch FILE", "adds FILE to watch list"
	def watch(file)
		require 'ngrep'
		Ngrep::Db.connect		
		Ngrep::WatchList.add file
		puts "Added #{file} to watch list. Do rehash too"
	end

	desc "unwatch FILE", "removes file from watch list"
	option :all, :type => :boolean, :aliases => :a
	def unwatch(file)
		require 'ngrep'
		Ngrep::Db.connect
		if options[:all]
			Ngrep::WatchList.clear
		else
			Ngrep::WatchList.remove file
			puts "Removed #{file} from watch list. Do rehash too"
		end		
	end

	desc "watchlist", "shows the watch list"
	def watchlist
		require 'ngrep'
		Ngrep::Db.connect
		puts Ngrep::WatchList.show	
	end	

	desc "hi", "just loads the Ngrep application"
	def hi
		require 'ngrep'
	end

	#default_task :search ## doesn't work right
end

#Ng.start  # uncomment to make this a shell command

