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
			word_detail = self.build(word, detail_str)
			yield word_detail  if block_given?
			word_detail
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

	def build_result(options={})
		build_header + header_end(options) +
		lines_from_file(options).
			cleanup.
			mark_result(options).   # mark line with the exact match
			to_s
	end

	def build_header
		file_path_small + ':' + @line_no.to_s
	end

	def file_path_small
		@file_path.to_s.sub(File.expand_path('~'), '~')
	end

	def header_end(options={})
		options[:pre].to_i==0 &&
		options[:post].to_i==0 ?  ':' : ":\n "
	end

	def lines_from_file(options={})
		pre = options[:pre].to_i
		post = options[:post].to_i

    lines = []
    File.open(@file_path) do |f|
      skip = @line_no.to_i - pre
      skip.times{ f.gets }
      num  = pre + post + 1
      lines = (1..num).map{ f.gets }
    end
    ResultLines.new lines
  end

end