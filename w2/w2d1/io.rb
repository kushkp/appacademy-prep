def numGuess
  comp_num = 1 + rand(10)
  num_guesses = 1
  puts "Guess my number: "
  user_guess = gets.to_i
  while user_guess != comp_num
    user_guess < comp_num ? (puts "too low :(") : (puts "too HIGH!")
    puts "Try again: "
    num_guesses += 1
    user_guess = gets.to_i
  end
  puts "Yay! You guessed my number in #{num_guesses} tries!"
end

def fileShuffler
  puts "Wchih flie wulod you lkie to sfluhfe?"
  file_name = gets.chomp
  contents = File.readlines(file_name)
  contents.shuffle!
  File.open("#{file_name}-shuffled.txt", "w") { |f| f.puts contents }
end


#test
# numGuess
# fileShuffler
