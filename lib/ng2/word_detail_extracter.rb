class Ng2::WordDetailExtracter
  
  attr_accessor :project, :file_path, :current_date

  def from_file(path, options={})
    from_lines File.readlines(path), file_path: path 
  end

  def from_lines(lines, options)
    i = options[:offset] || 0
    lines.map do |line|
      i += 1
      from_line(line, 
        line_no: options[:offset] + i,
        file_path: options[:path])
    end.flatten
  end

  def from_line(line, options)
    j = 0
    parse_words(line).map do |word|
      j += 1
      WordDetail.new(word, 
        project:   parse_project(options[:file_path],
        file_path: options[:file_path],
        line_no:   options[:line_no],
        word_no:   j)
    end
  end

  def parse_words(line)
    line.split(/\s/)
  end

  def parse_project(file_path)
    return @project if @project
    file_path.match(/\/code\/(.+)\//) do |matches|
      @project = matches[1].split("/").first if matches[1]
    end
    @project
  end

  #def parse_date(line)
  # prev_date = @current_date
  # line.match(/## (.+)/) do |matches|
  #   parsed_date = Date.parse(matches[1]) rescue nil
  # end
  # @current_date = parsed_date || prev_date
  #end

end

# WordDetailExtracter
# => is given a file
# => extracts WordDetailPair objects from the file

# alternative algorithm:
# line-no and file-path can identify a word uniquely
# first traversal can create WordDetail objects for the words
# second traversal can assign the date and project values
# 