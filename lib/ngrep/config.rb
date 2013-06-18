module Ngrep
	Config = {
		data_file: File.expand_path("~/.ngrep/hash.json"),
		watch_file: File.expand_path("~/.ngrep/watch_file"),
		db_file: File.expand_path("~/.ngrep/ngrep.sqlite3")
	}
end