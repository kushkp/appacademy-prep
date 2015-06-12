class Hangman
	attr_reader :guessing_player, :checking_player, :secret_word, :guessed_word

  def initialize
     @guessing_player = nil
     @checking_player = nil
     @secret_word = []
     @guessed_word = []
  end

  def play
    set_up_players(how_many_players)
    @secret_word = checking_player.pick_secret_word.split("")
		@guessed_word = Array.new(secret_word.length) { "_" }

		if guessing_player.class == Computer
			guessing_player.limit_words(guessing_player.receive_secret_length)
			guessing_player.parse_word_bank
		end

		until guessed_word == secret_word
			display_word
			letter = guessing_player.get_input
			modify(guess(letter), letter)
		end

  	winner_winner
  end

  private

  def winner_winner
  	puts "Correct! The word was #{@secret_word.join}!"
  	puts "You've beaten the game #{guessing_player.name}!"
  end

  def guess(letter)
  	indices = []
  	secret_word.each_with_index { |char, idx| indices << idx if char == letter }
    indices
  end

  def modify(indices, letter)
  	indices.each { |idx| @guessed_word[idx] = letter }
  end

  def display_word
    puts guessed_word.join
  end

  #prompts user for number of players
  def how_many_players
    puts "How many human players are there?"
    num = gets.chomp.to_i
    until num.between?(1, 2)
      puts "Please choose a number between 1-2"
      num = gets.chomp.to_i
    end
    num
  end

  #sets up human players and/or computer players
  def set_up_players(num)
    case num
    when 1
    	puts "Do you want to guess or check?"
    	reply = gets.chomp
    	if reply == "guess"
	      @guessing_player = Player.new(1)
	      @checking_player = Computer.new
	    else
	     	@guessing_player = Computer.new
	      @checking_player = Player.new(1)
      end
    when 2
      @guessing_player = Player.new(1)
      @checking_player = Player.new(2)
    end
  end
end

class Computer
	attr_reader :dictionary, :player_num, :name, :letter, :guessed_letters, :letter_frequency

	def initialize
		@dictionary = nil
		@name = "Siri"
		@guessed_letters = []
		@dictionary = dictionary_file
	end

	def pick_secret_word
		dictionary.sample
	end

	def get_input
		@letter = @letter_frequency.shift[0]
		@guessed_letters << letter
		letter
	end

	def receive_secret_length
		puts "How long is your word?"
		gets.chomp.to_i
	end

	def limit_words(longness)
		@word_bank = @dictionary.select { |word| word.length == longness }
	end

	def parse_word_bank
		frequency = Hash.new(0)
		@word_bank.each do |word|
			word.each_char do |char|
				frequency[char] += 1
			end
		end
		@letter_frequency = frequency.sort_by { |k, v| v }.reverse.to_h
	end

	private

	#def get_letter
	#	(97 + rand(26)).chr
	#end

	def dictionary_file
		words = File.readlines("dictionary.txt")
		words.map! {|word| word.chomp}
		words
	end
end

class Player
	attr_reader :player_num, :name, :letter, :guessed_letters, :secret_word, :dictionary

	def initialize(num)
		@player_num = num
		@name = username
		@letter = nil
		@guessed_letters = []
		@secret_word = nil
	end

	def get_input
		get_letter
		checks
		@guessed_letters << letter
		letter
	end

	def pick_secret_word
		@dictionary = dictionary_file
		until dictionary.include?(secret_word)
			puts "Choose a valid word."
			@secret_word = gets.chomp.downcase
		end
		secret_word
	end

	private

	def checks
		until valid_guess?(letter)
			if repeat_guess?(letter)
				repeat_error
				get_letter
			elsif !check_letter?(letter)
				valid_error
				get_letter
			end
		end
	end

	def get_letter
		print "Pick a letter: "
		@letter = gets.chomp[0]
	end

	def username
		puts "What is player #{player_num}'s name?"
		gets.chomp.capitalize
	end

	def check_letter?(letter)
		return false if (letter =~ /[A-Za-z]/).nil?
		return true
	end

	def valid_guess?(letter)
	  check_letter?(letter) && !repeat_guess?(letter)
	end

	def repeat_guess?(letter)
		@guessed_letters.include?(letter)
	end

  def valid_error
  	puts "Please choose a valid alphabetical character."
  end

  def repeat_error
  	puts "You've already guessed the letter #{@letter}."
  end

	def dictionary_file
		words = File.readlines("dictionary.txt")
		words.map! {|word| word.chomp}
		words
	end
end
