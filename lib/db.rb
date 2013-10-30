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

		def self.migrations
			require File.expand_path("../db/create_words_migration.rb", __FILE__)
			[Ngrep::CreateWordsMigration]
		end

		def self.run_migrations
			self.migrations.map(&:run)
		end
		
		
	end
end