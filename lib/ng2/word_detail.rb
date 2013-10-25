class Ng2::WordDetail

	attr_accessor :word, :file_path, :line_no, :word_no, :serialized_details

	def initialize(word, details={})
		@word      = word
		@file_path = details[:file_path]
		@line_no   = details[:line_no]
		@word_no   = details[:word_no]
	end

	def self.build(word, detail_str)
		wd = self.new(word)
		wd.serialized_details = detail_str
		wd.deserialize
		wd
	end

	def self.find(word)
		Ng2::HashDb.get(word).map do |detail_str|
			self.build(word, detail_str)
		end
	end

	# true if there's a word in the hash-db with the same file_path and line_no
	def duplicate?
		other = Ng2::WordDetail.find(@word).last
		!other.nil? &&
		other.file_path == self.file_path &&
		other.line_no   == self.line_no   &&
		other.word_no   == self.word_no
	end

	# serialize and save the word along with details to hash_db 
	def save
		Ng2::HashDb.add(@word, serialize)
	end

	def serialize
		[@file_path, @line_no, @word_no].join(",") # TODO: add escaping
	end

	def deserialize
		@file_path, @line_no, @word_no = @serialized_details.split(",") # TODO: add de-escaping
	end

end