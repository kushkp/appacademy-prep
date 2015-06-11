class Dictionary
  attr_reader :dict

  def initialize
    @dict = {}
  end

  def entries
    dict
  end

  def add(options = {})
    if options.class == Hash
      dict.merge!(options)
    elsif options.class == String
      dict[options] = nil
    end
  end

  def keywords
    dict.keys.sort
  end

  def include?(string)
    dict.include?(string)
  end

  def find(prefix)
    @dict.select {|word| word =~ /^#{prefix}/ }
  end

  def printable
    print = ""
    keywords.each do |word|
      print << %Q{[#{word}] "#{dict[word]}"\n}
    end
    print.chomp!
  end

end
