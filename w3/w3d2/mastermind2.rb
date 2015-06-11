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
    exacts, nears = @master_code.matches(user_code)
    [exacts, nears]
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

  def matches(user_code)
    exact_match_indices = find_exact_match_indices(user_code)
    exact_matches = exact_match_indices.count
    master_working, user_code_working = delete_by_indices(exact_match_indices, user_code)
    near_matches = find_near_matches(master_working, user_code_working)
    [exact_matches, near_matches]
  end

  private

  def find_exact_match_indices(user_code)
    exact_match_indices = []
    @code.each_index do |i|
      exact_match_indices << i if @code[i] == user_code.code[i]
    end
    exact_match_indices
  end

  def delete_by_indices(indices,user_code)
    master_working, user_code_working = [],[]
    user_code.code.each_with_index do |letter, i|
      user_code_working << letter unless indices.include?(i)
    end

    @code.each_with_index do |letter, i|
      master_working << letter unless indices.include?(i)
    end

    [master_working,user_code_working]
  end

  def find_near_matches(master_working,user_code_working)
    near_matches = 0
    user_code_working.each do |letter|
      if master_working.include?(letter)
        master_working.delete_at(master_working.index(letter))
        near_matches += 1
      end
    end
    near_matches
  end
end

Game.new.play
