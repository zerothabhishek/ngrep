class Ng2::SearchHandler


  # under consideration. Missing the uniqueness check
  # Other one is better because it can use threads easily
  def search2(pattern, options) 
    Ng2::WordDetail.find(pattern) do |word_detail|
      build_result(word_detail, options)
      show_result
    end    
  end

  def search(pattern, options)
    find_words(pattern)
    filter_uniques
    show_results(options)
  end

  def find_words(pattern)
    @word_details = Ng2::WordDetail.find(pattern)
  end

  def filter_uniques
    @word_details = @word_details.uniq do |word_detail| 
      word_detail.line_no 
    end
  end

  def show_results(options)
    @word_details.each do |word_detail|
      show_result word_detail.build_result(options) 
    end  
  end

  def show_result(result)
    puts result
  end

  def self.search(pattern, options)
    Ng2::HashDb.setup_searcher
    self.new.search(pattern, options) #opions: {pre: 2, post: 3}
    Ng2::HashDb.teardown_searcher
  end 
  
end