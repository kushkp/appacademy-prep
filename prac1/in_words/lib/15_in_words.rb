class Fixnum
    SMALLS = {0 =>"zero", 1 => "one", 2 => "two", 3 => "three", 4 => "four", 5 => "five", 6 => "six", 7 => "seven", 8 => "eight", 9 => "nine", 10 => "ten", 11 => "eleven", 12 => "twelve", 13 => "thirteen", 14 => "fourteen", 15 => "fifteen", 16 => "sixteen", 17 => "seventeen", 18 => "eighteen", 19 => "nineteen", 20 => "twenty", 30 => "thirty", 40 => "forty", 50 => "fifty", 60 => "sixty", 70 => "seventy", 80 => "eighty", 90 => "ninety"}

    MAGNITUDE_WORD = {100 => "hundred", 1000 => "thousand", 1000000 => "million", 1000000000 => "billion", 1000000000000 => "trillion"}

  def in_words
    if SMALLS.include?(self)
      SMALLS[self]
    elsif self < 100
      "#{SMALLS[(self / 10) * 10]} " + (self % 10).in_words
    else
      magnitude = find_mag
      magnitude_words = "#{(self / magnitude).in_words} #{MAGNITUDE_WORD[magnitude]}"
      if self % magnitude == 0
        magnitude_words
      else
        magnitude_words + " " + (self % magnitude).in_words
      end
    end
  end

  def find_mag
    MAGNITUDE_WORD.keys.select {|mag| mag <= self}.last
  end
end
