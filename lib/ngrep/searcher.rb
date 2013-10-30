module Ngrep
	class Searcher

		def self.find(word, args={})
			self.new.find(word, args)
		end

		def find(word, args)
			results = Ngrep::Word.where(value: word)
			pre = args[:pre] || 0
			post = args[:post] || 0
			results_strs = results.map{|w| result_string(w, pre, post)}
			results_strs.join("\n")
		end

		def result_string(r, pre, post)
			str = "*** "
			str += r.project
			str += "; "
			str += r.line_number.to_s
			str += pre==0 && post==0 ? "; " : "> "
			lines = readlines(r.file_path, r.line_number, pre, post)
			str += lines
			str
		end

		def readlines(file_path, line_number, pre, post)
			lines = []
			File.open(file_path) do |f|
				skip = line_number - pre -1
				num = pre + post + 1 
				skip.times{ f.gets }
				lines = (1..num).map{ f.gets }
			end
			lines = lines.map(&:chomp)
			sep = pre==0 && post==0 ? "" : "\n>"
			lines.join(sep)
		end

	end	
end
