 
#require "bundler/setup"
#Bundler.setup(:default)
require 'kyotocabinet'

module Ng2; end

load File.expand_path '../ng2/hash_db.rb', __FILE__
load File.expand_path '../ng2/result_lines.rb', __FILE__
load File.expand_path '../ng2/word_detail.rb', __FILE__
load File.expand_path '../ng2/word_detail_extracter.rb', __FILE__
load File.expand_path '../ng2/watch_handler.rb', __FILE__
load File.expand_path '../ng2/search_handler.rb', __FILE__
load File.expand_path '../ng2/watch_scanner.rb', __FILE__

module Ng2
  class<<self

  	def search(pattern, options={})
  		Ng2::SearchHandler.search(pattern, options)
  	end

    def hash(options={})
      Ng2::HashDb.setup
      Ng2::WordDetailExtracter.new.from_file(options[:file]) do |word_detail|
        word_detail.save  unless word_detail.duplicate?
      end
      Ng2::HashDb.teardown
    end

    def hash_all(options={})
      Ng2::HashDb.setup

      list = Ng2::WatchHandler.list
      puts "Starting to hash #{list.size} files..." if options[:verbose]

      list.each do |file|
        puts file if options[:verbose]
        begin 
          Ng2::WordDetailExtracter.new.from_file(file) do |word_detail|
            word_detail.save  unless word_detail.duplicate?
          end
        rescue => e
          puts "--->Error in #{file}"
          puts e.message
          p e.backtrace
        end
      end
      Ng2::HashDb.teardown
    end

    def delete_hash
      Ng2::HashDb.setup
      Ng2::HashDb.clear
      Ng2::HashDb.teardown
    end

  	def watch(file, options={})
      Ng2::HashDb.setup
  		Ng2::WatchHandler.watch(file, options)
      Ng2::HashDb.teardown
  	end

  	def unwatch(file)
      Ng2::HashDb.setup
  		Ng2::WatchHandler.unwatch(file, options)
      Ng2::HashDb.teardown
  	end

  	def watchlist
      Ng2::HashDb.setup
  		puts Ng2::WatchHandler.list
      Ng2::HashDb.teardown
  	end

    def watchscan(dir, options={})
      Ng2::HashDb.setup
      puts "----> Scanned files:" if options[:verbose]
      Ng2::WatchScanner.new(dir, options).scan do |file| 
        puts file if options[:verbose]
        Ng2::WatchHandler.watch(file)
      end
      Ng2::HashDb.teardown
    end

    def info
      Ng2::HashDb.setup
      puts "Watchlist size: " + Ng2::WatchHandler.list.size.to_s + " files"
      puts "Hashdb size: "    + Ng2::HashDb.size.to_s            + " keys"
      puts "HashDb size: "    + Ng2::HashDb.db_scanner.size.to_s + " bytes"
      Ng2::HashDb.teardown
    end

  end
end

