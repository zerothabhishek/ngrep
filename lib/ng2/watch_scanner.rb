require 'find'
class Ng2::WatchScanner

	NotesRegex = /.*notes.*/
	DefaultScanDepth = 5

	attr_reader :scan_count, :scan_depth, :scan_root

	def initialize(dir, options={})
		@scan_root = File.expand_path(dir)
		@scan_depth = (options[:depth] || DefaultScanDepth).to_i
		@scan_count = 0
	end

	def scan
		Find.find(@scan_root) do |file_path|
			@scan_count += 1
			Find.prune if prunable?(file_path)  # prune is like next
			Find.prune if too_deep?(file_path)
			if notable?(file_path)
				yield file_path
			end
		end		
	end

	def notable?(file_path)
		!!(File.basename(file_path) =~ NotesRegex) && 
		File.readable?(file_path) &&
		['.md', '.txt'].include?(File.extname(file_path))
	end

	def prunable?(file_path)
		File.basename(file_path)[0] == '.'
	end

	def too_deep?(file_path)
		absolute_depth0 = @scan_root.split("/").size - 1
		absolute_depth1 = file_path.split("/").size - 1
		absolute_depth1 - absolute_depth0 >= @scan_depth
	end

end