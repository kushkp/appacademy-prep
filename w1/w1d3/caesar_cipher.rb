def caesar_cipher(string, shift_by=3)
  letters = string.split("")
  shifted_letters = []
  letters.each do |letter|
    shifted_letters << shift_letter(letter, shift_by)
  end
  shifted_string = shifted_letters.join
end

def shift_letter(letter,shift_by)
  new_ord = letter.ord + shift_by
  #new max == 122 - shift_by
  if new_ord > 122
    new_ord = new_ord % 123 + 97
  end
  new_ord.chr
end

#97 a, 122 z
#test
p caesar_cipher("hello",3)
p caesar_cipher("zbc",1)
