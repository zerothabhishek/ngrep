class Ng2::WatchHandler

	@@watch_list=[]

	def self.watch(file, options={})
		load
		@@watch_list.push(file) unless @@watch_list.include?(file)
		@@watch_list.flatten!
		save
	end

	def self.unwatch(file, options={})
		load
		@@watch_list.delete(file)
		save
	end

	def self.list
		load
		@@watch_list
	end

	def self.load
		#@@watch_list = deserialize Ng2::HashDb.new.get(watch_list_key).to_s
		@@watch_list = Ng2::HashDb.get(watch_list_key)
	end

	def self.save
		#Ng2::HashDb.new.set(watch_list_key, serialize(@@watch_list))
		Ng2::HashDb.set(watch_list_key, serialize(@@watch_list))
	end

	def self.deserialize(str)
		str.split("|")
	end

	def self.serialize(list)
		list.join("|")
	end
	
	def self.watch_list_key
		"Ng2::WatchList" +
		"6eecc4697ffba2ada42b84c7c5c5537a"  # this is a random long string		
	end
	
end
