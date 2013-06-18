
t0=Time.now
require 'bundler/setup'
t1=Time.now
puts "bundler/setup time: #{t1-t0}"

require 'json'

t0=Time.now
require 'active_support/time'
t1=Time.now
puts "active_support load time: #{t1-t0}"

t0=Time.now
require 'active_record'
#module ActiveRecord
#	class Base
#		def self.establish_connection(args)
#		end
#	end	
#end
t1=Time.now
puts "active_record load time: #{t1-t0}"


require File.expand_path("../ngrep/config.rb", __FILE__)
require File.expand_path("../ngrep/word.rb", __FILE__)
require File.expand_path("../ngrep/hash.rb", __FILE__)
require File.expand_path("../ngrep/build.rb", __FILE__)
require File.expand_path("../ngrep/search.rb", __FILE__)
require File.expand_path("../ngrep/watch_list.rb", __FILE__)
require File.expand_path("../db.rb", __FILE__)

module Ngrep

	def self.root
		File.expand_path("..",__FILE__)
	end	
end
