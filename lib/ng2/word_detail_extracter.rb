class Ng2::WordDetailExtracter
  
  attr_accessor :project, :file_path, :current_date

  def from_file(path, options={})
    from_lines File.readlines(path), file_path: path 
  end

  def from_lines(lines, options={})
    options[:offset] ||= 0
    i = options[:offset]
    lines.map do |line|
      i += 1
      from_line(line, 
        line_no: i,
        file_path: options[:file_path])
    end.flatten
  end

  def from_line(line, options={})
    j = 0
    parse_words(line).select{|word| word.size>0}.map do |word|
      j += 1
      Ng2::WordDetail.new(word,
        file_path: options[:file_path],
        line_no:   options[:line_no],
        word_no:   j)
    end
  end

  def parse_words(line)
    line.split(/\s/).map{|word| remove_punctuations(word)}
  end

  def remove_punctuations(word)
    punctuation_marks = %w(, ; .)
    last_index = word.size-1
    word.chop! if punctuation_marks.include? word[last_index]
    word
  end

end

# WordDetailExtracter
# => is given a file
# => extracts WordDetailPair objects from the file

# alternative algorithm:
# line-no and file-path can identify a word uniquely
# first traversal can create WordDetail objects for the words
# second traversal can assign the date and project values
# 