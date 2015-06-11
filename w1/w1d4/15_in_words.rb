class Fixnum
  def in_words
    num_strings = {
      0 => "zero",
  	  1 => "one",
  	  2 => "two",
  	  3 => "three",
  	  4 => "four",
  	  5 => "five",
  	  6 => "six",
  	  7 => "seven",
  	  8 => "eight",
  	  9 => "nine",
  	  10 => "ten",
  	  11 => "eleven",
  	  12 => "twelve",
  	  13 => "thirteen",
  	  14 => "fourteen",
  	  15 => "fifteen",
  	  16 => "sixteen",
  	  17 => "seventeen",
  	  18 => "eighteen",
  	  19 => "nineteen",
  	  20 => "twenty",
  	  30 => "thirty",
  	  40 => "forty",
  	  50 => "fifty",
  	  60 => "sixty",
  	  70 => "seventy",
  	  80 => "eighty",
  	  90 => "ninety",
  	}

  	if self <= 20 || (self % 10 == 0 && self < 100)
  	  num_strings[self]
  	elsif self < 100
  	  "#{num_strings[(self/10)*10]} #{num_strings[self%10]}"
  	elsif self < 1000
  	  self % 100 == 0 ? "#{num_strings[self/100]} hundred" : "#{num_strings[self/100]} hundred #{(self % 100).in_words}"
  	elsif self < 1_000_000
  	  self % 1000 == 0 ? "#{num_strings[self/1000]} thousand" : "#{(self/1000).in_words} thousand #{(self % 1000).in_words}"
  	elsif self < 1_000_000_000
  	  p self % 1_000_000 == 0 ? "#{num_strings[self/1_000_000]} million" : "#{(self/1_000_000).in_words} million #{(self % 1_000_000).in_words}"
  	elsif self < 1_000_000_000_000
  	  self % 1_000_000_000 == 0 ? "#{num_strings[self/1_000_000_000]} billion" : "#{(self/1_000_000_000).in_words} billion #{(self % 1_000_000_000).in_words}"
  	elsif self < 1_000_000_000_000_000
  	  self % 1_000_000_000_000 == 0 ? "#{num_strings[self/1_000_000_000_000]} trillion" : "#{(self/1_000_000_000_000).in_words} trillion #{(self % 1_000_000_000_000).in_words}"
  	end
  end
end
