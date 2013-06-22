require File.expand_path("../../ngrep.rb", __FILE__)
Ngrep::Db.connect

ActiveRecord::Migration.create_table(:words) do |t|
		t.string :value
		t.string :project
		t.string :file_path 
		t.integer :line_number
		t.datetime :date 
		t.timestamps
end