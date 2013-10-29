require 'kyotocabinet'

class Ng2::HashDb

	@@db_scanner  = nil
	@@db_searcher = nil
	@@db_file     = nil

	## Getters and setters
	def self.db_scanner
		@@db_scanner
	end

	def self.db_scanner=x
		@@db_scanner=x
	end

	def self.db_file
		@@db_file
	end

	def self.db_file=x
		@@db_file=x
	end

	def self.db_searcher
		@@db_searcher
	end

	def self.default_db_path
		ENV && ENV=='test' ?
			File.expand_path('../../../tmp/hash.kch', __FILE__) :
			File.expand_path("~/.ng2/hash.kch")
	end

	## Main api
	def self.add(key, given_value)
		existing_value = self.get(key)
		value = existing_value.size==0 ? given_value :
						concat(existing_value, given_value)
		self.set(key, value)
	end

	def self.set(key, value)
		raise "HashDb.setup first" unless @@db_scanner
		@@db_scanner.set(key, value) or raise "Can't set on the KC db"
	end

	def self.get(key)
		raise "HashDb.setup first" if @@db_scanner.nil? && @@db_searcher.nil?
		db_reader = @@db_scanner || @@db_searcher
		value_str = db_reader.get(key)
		value_str ? value_str.split("|") : []
	end

	def self.clear
		@@db_scanner.clear
	end

	def self.size
		count = 0
		Ng2::HashDb.db_scanner.each_key{|k| count += 1 }
		# Ng2::HashDb.db_scanner.size gives the size in bytes
		count
	end

	def self.concat(existing_values, new_value)
		arr = existing_values.push new_value.to_s
		arr.flatten
		arr.join("|")
	end

	## Scanner
	def self.setup
		@@db_file = self.default_db_path
		open_scanner
	end

	def self.teardown
		@@db_scanner.close
		@@db_scanner = nil
	end

	def self.open_scanner
		@@db_scanner = KyotoCabinet::DB.new
		@@db_scanner.open(@@db_file.to_s,         # to_s because it doesn't fail when @@db_file is nil
			KyotoCabinet::DB::OWRITER |
			KyotoCabinet::DB::OCREATE)    or raise "Can't open the KC db"
	end

	# db_scanner  [not used anywhere]
	# - used in rehashing and watch_handling
	# - used in testing, as value verification can't be done w/o reopening the db
	# - can do both read and write
	# - will be blocked if there is another thread with a searcher
	# - will block other read-write threads
	def self.with_scanner
		setup
		yield
		teardown
	end

	# searcher
	def self.setup_searcher
		@@db_file = self.default_db_path
	  @@db_searcher = KyotoCabinet::DB.new
	  @@db_searcher.open(@@db_file, KyotoCabinet::DB::OREADER) or raise "Can't open the KC db"
	end

	def self.teardown_searcher
	  @@db_searcher.close
	  @@db_searcher = nil
	end

	# db_searcher  [not used anywhere]
	# - used only for reading (get)
	# - can't get latest values: those that the same thread may be writing
	# - can be used for threaded read
	# - will be blocked if a scanner runs in another thread
	def self.with_searcher
		setup_searcher
		yield
		teardown_searcher
	end

end