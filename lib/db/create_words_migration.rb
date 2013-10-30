#require File.expand_path("../../ngrep.rb", __FILE__)
#Ngrep::Db.connect

class Ngrep::CreateWordsMigration

	def self.run
		ActiveRecord::Migration.create_table(:words) do |t|
				t.string :value
				t.string :project
				t.string :file_path 
				t.integer :line_number
				t.date :date 
				t.timestamps		
		end
		ActiveRecord::Migration.add_index(:words, :value)
	end

end