module Ngrep
	Config = {
		:production => {
			data_file: File.expand_path("~/.ngrep/hash.json"),
			watch_file: File.expand_path("~/.ngrep/watch_file"),
			db_file: File.expand_path("~/.ngrep/ngrep.sqlite3")			
		},
		:test => {
			data_file:  File.expand_path("/tmp/hash.json"),
			watch_file: File.expand_path("/tmp/watch_file"),
			db_file:   File.expand_path("/tmp/ngrep.sqlite3")
		}
	}
end