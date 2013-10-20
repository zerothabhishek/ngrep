require "bundler/setup"
Bundler.require(:default)

$:.unshift File.dirname(__FILE__)
require "ng2/version"
require "ng2/index"
require "ng2/index_item"
require "ng2/search_handler"
require "ng2/watch_handler"


module Ng2
  class<<self

  	def search(pattern, options={})
  		Ng2::SearchHandler.search(pattern, options)
  	end

  	def hash(options={})
      word_details = Ng2::WordDetailExtracter.new.from_file(options[:file])
      word_details = word_details.select{|word_detail| !word_detail.duplicate? }
      word_details.map(&:save)
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
