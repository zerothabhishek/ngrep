require File.expand_path("../../ngrep.rb", __FILE__)
Ngrep::Db.connect

ActiveRecord::Migration.add_index(:words, :value)
