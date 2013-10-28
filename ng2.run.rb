load File.expand_path '../lib/ng2.rb', __FILE__

def clear_it
	Ng2::HashDb.setup
	Ng2::HashDb.clear
	Ng2::HashDb.teardown
end

def hash_it
	#f = "/Users/abhishekyadav/code/ngrep-proj/notes.md"
	f = "/Users/abhishekyadav/code/ngrep-proj/ng2/tmp/sample1.notes.txt"
	Ng2.hash2 file: f
end

def the_keys
	Ng2::HashDb.setup
	keys = []
	Ng2::HashDb.db_scanner.each_pair{|k,v| keys << k }
	Ng2::HashDb.teardown
	keys.each do |k| 
		print k; print "; "
	end
end

def the_value
	Ng2::HashDb.setup
	key = ARGV[0]
	value = Ng2::HashDb.get key
	puts value
	Ng2::HashDb.teardown
end

def the_search
	#Ng2.search(ARGV[0], pre:1, post: 1)
	#Ng2.search(ARGV[0], pre:1, post: 0)
	#Ng2.search(ARGV[0], pre:0, post: 1)
	Ng2.search(ARGV[0])
end

#the_keys
#the_value
#clear_it; hash_it
the_search



