require 'json'
require 'active_support/time'
require 'active_record'


require File.expand_path("../lib/config.rb", __FILE__)
require File.expand_path("../lib/word.rb", __FILE__)
require File.expand_path("../lib/hash.rb", __FILE__)
require File.expand_path("../lib/build.rb", __FILE__)
require File.expand_path("../lib/search.rb", __FILE__)
require File.expand_path("../lib/watch_list.rb", __FILE__)
require File.expand_path("../db.rb", __FILE__)

module Ngrep

	def self.root
		File.expand_path("..",__FILE__)
	end	
end
