class Game

  def initialize
    @master_code = Code.new
  end

  def play
    i = 0
    puts "Welcome to Mastermind! Options: Red, Orange, Yellow, Green, Blue, Purple. (ex: RGBG)"

    while i < 10
      puts "Turn #{i + 1} of 10:"
      user_input = prompt
      match_results = check_against_code(user_input)
      if win?(match_results)
        puts "Congratulations! You Win!"
        break
      else
        puts "#{match_results[0]} exact matches, #{match_results[1]} near matches"
      end
      i += 1
    end

    puts "Sorry, you lose! Play again? (y/n)"
    if gets.chomp.downcase == "y"
      Game.new.play
    else
      puts "Goodbye!"
    end
  end

  def win?(match_results)
    match_results == [4,0]
  end

  def prompt
    possible_guesses = [:R, :O, :Y, :G, :B, :P]
    puts "Guess my secret code!"
    valid_input = false

    until valid_input
      input = gets.chomp.split("")
      input.map! { |letter| letter.to_sym }
      if input.count == 4 && input.all? { |letter| possible_guesses.include?(letter) }
        valid_input = true
      else
        puts "Invalid input. Try Again."
      end
    end

    return Code.new(user_code: input)
  end

  def check_against_code(user_code)
    exacts = @master_code.exact_matches(user_code)
    nears = @master_code.near_matches(user_code)
    [exacts,nears]
  end
end

class Code

  attr_accessor :POSSIBLE_COLORS, :code

  def initialize(options = {})
    @POSSIBLE_COLORS = [:R, :O, :Y, :G, :B, :P]
    if options == {}
      # @code = random
      @code = [:B,:B,:Y,:Y]
    else
      @code = options[:user_code]
    end
  end

  def random
    random_code = []
    4.times { random_code << @POSSIBLE_COLORS.sample }
    random_code
  end

  def exact_matches(user_code)
    count_matches = 0
    user_code.code.each_index do |i|
      count_matches += 1 if @code[i] == user_code.code[i]

    end
    count_matches
  end

  def near_matches(user_code)
    new_user_code, new_master_code = delete_exact_matches(user_code)

    count_matches = 0
    new_user_code.each do |letter|
      if new_master_code.include?(letter)
        new_master_code.delete_at(new_master_code.index(letter))
        count_matches += 1
      end
    end
    count_matches
  end

  def delete_exact_matches(other_code)
    exact_match_indices = []
    4.times do |i|
      exact_match_indices << i if @code[i] == other_code.code[i]
    end
    new_codes = [[],[]]

   other_code.code.each_with_index do |letter, i|
      new_codes[0] << letter unless exact_match_indices.include?(i)
    end

    @code.each_with_index do |letter, i|
      new_codes[1] << letter unless exact_match_indices.include?(i)
    end

    new_codes
  end
end

Game.new.play
