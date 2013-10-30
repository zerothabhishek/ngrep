class Ngrep::Indexer

	#ProjectRegex = /\/code\/(.+)\//
	ProjectRegex = /.*\/code\/(.+)/
	DateRegex = /## (.+)/

	def self.rehash(file)
		self.new.rehash_f(file)
	end	

	def initialize
		@current_date = nil
	end

	def rehash_f(file_path)
		project = parse_project(file_path)
		f = File.open(file_path) 
		f.each do |line|
			rehash_l(line, 
				project: project, 
				file_path: file_path, 
				line_number: f.lineno)
		end
	end

	def rehash_l(line, args)	
		date = parse_date(line) || @current_date 
		get_words(line).each do |word|
			Ngrep::Index.add(word, args.merge({date: date}))
		end
	end

	def parse_project(file_path)
		parsed_project = nil
		file_path.match(ProjectRegex) do |matches|
			parsed_project = matches[1].split("/").first if matches[1]	
		end
		parsed_project
	end

	def parse_date(line)
		line.match(DateRegex) do |matches|
			parsed_date   = Date.parse(matches[1]) rescue nil
			@current_date = parsed_date if parsed_date
		end
		@current_date
	end

	def get_words(line)
		line.split(/\s/)		
	end

end