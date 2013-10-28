
#require "bundler/setup"
#Bundler.setup(:default)
require 'kyotocabinet'
require 'thor'

module Ng2; end

load File.expand_path '../ng2/hash_db.rb', __FILE__
load File.expand_path '../ng2/result_lines.rb', __FILE__
load File.expand_path '../ng2/word_detail.rb', __FILE__
load File.expand_path '../ng2/word_detail_extracter.rb', __FILE__
load File.expand_path '../ng2/watch_handler.rb', __FILE__
load File.expand_path '../ng2/search_handler.rb', __FILE__



module Ng2
  class<<self

  	def search(pattern, options={})
  		Ng2::SearchHandler.search(pattern, options)
  	end

  	def hash(options={})
      Ng2::HashDb.setup
      word_details = Ng2::WordDetailExtracter.new.from_file(File.expand_path options[:file])
      word_details = word_details.select{|word_detail| !word_detail.duplicate? }
      word_details.map(&:save)
      Ng2::HashDb.teardown
  	end

    def hash2(options={})
      Ng2::HashDb.setup
      Ng2::WordDetailExtracter.new.from_file(options[:file]) do |word_detail|
        word_detail.save  unless word_detail.duplicate?
      end
      Ng2::HashDb.setup
    end

    def hash_all(options={})
      Ng2::WatchHandler.list.each do |file|
        self.hash(file: file)
      end
    end

  	def watch(file, options={})
  		Ng2::WatchHandler.watch(file, options)
  	end

  	def unwatch(file)
  		Ng2::WatchHandler.unwatch(file, options)
  	end

  	def watchlist	
  		Ng2::WatchHandler.list
  	end

  	def auto
  		Ng2::WatchHandler.enable_auto
  	end

  	def noauto
  		Ng2::WatchHandler.disable_auto
  	end

  end
end

