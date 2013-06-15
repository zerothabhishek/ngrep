require File.expand_path("../../application.rb", __FILE__)

ActiveRecord::Migration.create_table(:words) do |t|
		t.string :value
		t.string :project
		t.string :file_path 
		t.integer :line_number
		t.datetime :date 
		t.timestamps
end