
require File.expand_path('../../lib/ngrep.rb', __FILE__)

Ngrep.env = :test
Ngrep::Db.connect
Ngrep::Db.run_migrations


#require File.expand_path('../../lib/db/create_db.rb', __FILE__) 
#require File.expand_path('../../lib/db/create_words.rb', __FILE__)
#require File.expand_path('../../lib/db/create_words_index.rb', __FILE__) 
