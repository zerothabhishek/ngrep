module Ngrep

	class WatchList


		attr_reader :list

		def initialize
			@list = []
		end

		def watch_file
			Ngrep::Config[:watch_file]
		end

		def load
			@list = File.readlines(watch_file) || []
			@list = @list.map{|line| line.chomp }
		end

		def save
			File.write(watch_file, @list.join("\n"))
		end

		def add(file_path)
			@list << file_path unless @list.any?{|line| line==file_path}
		end

		def remove(file_path)
			@list = @list.reject{|line| line==file_path}
		end

		def clear
			@list = []
		end

		def self.add(file_name)
			file_path = File.expand_path file_name
			file_path.chomp!
			watch_list = WatchList.new
			watch_list.load
			watch_list.add(file_path)
			watch_list.save
		end

		def self.remove(file_name)
			file_path = File.expand_path file_name
			file_path.chomp!
			watch_list = WatchList.new
			watch_list.load
			watch_list.remove(file_path)
			watch_list.save			
		end

		def self.clear
			watch_list = WatchList.new
			watch_list.clear
			watch_list.save
		end

		def self.show
			File.read Ngrep::WatchList.new.watch_file
		end

	end
end


## Ngrep::WatchList