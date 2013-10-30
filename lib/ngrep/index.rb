class Ngrep::Index

	def self.install
		Ngrep::Db.connect
		Ngrep::Db.run_migrations
	end

	def self.add(word, args={})
		Ngrep::Word.create({value:word}.merge(args))
	end

	def self.find(word, args={})		
		Ngrep::Word.where({value: word}.merge(args))
	end

	def self.size		
		Ngrep::Word.count
	end
	
end