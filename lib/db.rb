module Ngrep
	class Db

		@@connection = nil
		
		def self.connect
			@@connection = ActiveRecord::Base.establish_connection(self.config)
		end

		def self.connection
			@@connection			
		end

		def self.config
			#database_path = File.join Ngrep.root, "db", "ngrep.sqlite3"
			database_path = Ngrep::Config[Ngrep.env.to_sym][:db_file]
			{adapter: 'sqlite3', database: database_path}			
		end
		
		
	end
end