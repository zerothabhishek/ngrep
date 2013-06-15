require File.expand_path("../../application.rb", __FILE__)

ActiveRecord::Migration.add_index(:words, :value)
