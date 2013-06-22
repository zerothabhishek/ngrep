require 'rspec'
require File.expand_path("../../lib/ngrep.rb", __FILE__)
Ngrep.env=:test
Ngrep::Db.connect


def flush_db
	Ngrep::Word.all.map(&:destroy)
end

def build_watch_list(list)
	list.map do |file_name| 
		file_path = File.join("/tmp", file_name)
		sample_data = ["## 1may2013", "notes1", "notes2"]*"\n"
		File.write(file_path, sample_data)
		file_path
	end
end