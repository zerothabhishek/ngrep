class ResultLines < Array

	def intitialize(lines)
		lines.each do |line|
			self << line
		end
	end

	def cleanup
		self.compact.map(&:chomp!)
		self
	end

	def mark_result(options)
		result_index = options[:pre].to_i
		result_line = self[result_index]
		result_line.prepend '-> '
		self
	end

	def to_s
		self.join("\n ")
	end
	
end