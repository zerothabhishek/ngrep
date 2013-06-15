require File.expand_path("../../application.rb", __FILE__)

ActiveRecord::Migration.create_table(:sample) do |t|
		t.string :name
end