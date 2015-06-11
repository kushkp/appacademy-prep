def num_to_s(num, base)
  digit_hash = {0 => "0", 1 => "1", 2 => "2", 3 => "3", 4 => "4", 5 => "5", 6 => "6", 7 => "7", 8 => "8", 9 => "9", 10 => "A", 11 =>"B", 12 => "C", 13 => "D", 14 => "E", 15 => "F"}

  numstring = ""
  i = 0

  until (base**i > num)
    char_digit = ""
    digit = ((num / (base**i)) % base)
    char_digit = digit_hash[digit]
    numstring = char_digit + numstring
    i += 1
  end
  p numstring
end

#test
num_to_s(5, 2)  #=> "101"
num_to_s(5, 3)  #=> "12"
num_to_s(5, 5)  #=> "10"
num_to_s(5, 10) #=> "5"
num_to_s(5, 16) #=> "5"


num_to_s(234, 2)  #=> "11101010"
num_to_s(234, 3)  #=> "22200"
num_to_s(234, 5)  #=> "1414"
num_to_s(234, 10) #=> "234"
num_to_s(234, 16) #=> "EA"
