##!/usr/bin/env ruby
require "thor"
Ng2Path = File.expand_path("../ng2.rb", __FILE__)

class Ng < Thor

	# ng [find] <pattern> -a <num-pre-lines> -b <num-post-lines> 
	desc "find PATTERN", "search the given term"
	option :pre, type: :numeric, aliases: :a
	option :post, type: :numeric, aliases: :b 
	def find(pattern)
		require Ng2Path
		Ng2.search(pattern, options)
	end

	# ng rehash -f <file-name>
	desc "hash", "rebuild the index"
	option :file, type: :string, aliases: :f
	def hash
		require Ng2Path
		Ng2.hash(options)
	end

	# ng watch <file-name>
	desc "watch FILE", "adds FILE to watch list"
	def watch(file)
		require Ng2Path
		Ng2.watch(file, options)
	end

	# ng unwatch <file-name>
	desc "unwatch FILE", "removes file from watch list"
	def unwatch(file)
		require Ng2Path
		Ng2.unwatch(file)
	end

	# ng watchlist
	desc "watchlist", "shows the watch list"
	def watchlist
		require Ng2Path
		Ng2.watchlist
	end

	# ng auto
	desc "auto", "enables auto-watch for watchlist"
	def auto
		require Ng2Path
		Ng2.auto(options)
	end

	# ng noauto
	desc "noauto", "disables auto-watch for watchlist"
	def noauto
		require Ng2Path
		Ng2.noauto(options)		
	end

	# ng hi
	desc "hi", "just loads the application"
	def hi
		require Ng2Path
		puts "hi"
	end

end

#Ng.start  # uncomment to make this a shell command

