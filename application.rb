require File.expand_path("../ngrep.rb", __FILE__)
t0=Time.now
Ngrep::Db.connect
t1=Time.now
puts "Database connect time: #{t1-t0}"