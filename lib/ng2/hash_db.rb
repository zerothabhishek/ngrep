require 'kyotocabinet'

class Ng2::HashDb

	attr_accessor :db

	def self.default_db_path
		File.expand_path("~/.ng2/hash.kc")
	end

	def initialize(db_path=nil)
		@db_file = db_path || self.default_db_path
		@db = KyotoCabinet::DB.new
	end

	def set(key, value)
		@db.open(@db_file, KyotoCabinet::DB::OWRITER | KyotoCabinet::DB::OCREATE)
		@db.set(key, value)
		@db.close
	end

	def get(key)
		@db.open(@db_file, KyotoCabinet::DB::OREADER)
		value = @db.get(key)
		@db.close
		value
	end

	def self.add(key, value)
		hash_db = self.new
		existing_value = hash_db.get(key)
		if existing_value
			value = existing_value + "|" + value
		end
		hash_db.set(key, value)
	end

	def self.get(key)
		hash_db = self.new
		value_str = hash_db.get(key)
		if value_str
			value_str.split("|")
		else
			[]
		end
	end


end