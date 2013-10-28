
require File.expand_path '../../lib/ng2.rb', __FILE__

gem "minitest", '5.0.8'
require 'minitest/autorun'

ENV = 'test' unless defined? ENV

module DbHelpers

	def test_db_path
		File.expand_path '../../tmp/hash.kch', __FILE__
	end

	def empty_test_db2
		Ng2::HashDb.with_scanner do 
			Ng2::HashDb.db_scanner.clear
		end
		#db = KyotoCabinet::DB.new
		#db.open(test_db_path, KyotoCabinet::DB::OWRITER | KyotoCabinet::DB::OCREATE)
		#db.clear
		#db.close
	end

	def db_set(key, value)
		db = KyotoCabinet::DB.new 
		db.open(test_db_path, KyotoCabinet::DB::OWRITER | KyotoCabinet::DB::OCREATE)
		db.set(key, value) 
		db.close	
	end

	def db_get(key)
		db = KyotoCabinet::DB.new 
		db.open(test_db_path, KyotoCabinet::DB::OREADER)
		value = db.get(key)
		db.close
		value
	end
end


