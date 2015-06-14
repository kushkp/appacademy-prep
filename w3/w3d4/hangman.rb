class Hangman
	def initialize(guessing_player, checking_player)
		@guessing_player = guessing_player
		@checking_player = checking_player
	end

	def play
		print_instructions
		@checking_player.pick_secret_word
		give_guesser_length
		until game_over?
			play_turn
		end
		print_end_message
	end

	private

	def give_guesser_length
		length = @checking_player.give_secret_length
		@guessing_player.receive_secret_length(length)
	end

	def print_instructions
		puts "Guess the secret word! Only 10 wrong guesses allowed."
	end

	def play_turn
			@checking_player.display_status
			puts "Misses: #{@checking_player.misses}"
			guess = @guessing_player.guess
			until @checking_player.valid_guess?(guess)
				guess = @guessing_player.guess
			end
			@checking_player.handle_guess_response(guess)
	end

	def game_over? #should this belong to player classes?
		@checking_player.word_guessed? || @checking_player.misses >= 10
	end

	def print_end_message #should this belong to player classes?
		# puts "The word was #{@checking_player.secret_word}." #then we can reference @secret_word variable from within the object
		@checking_player.print_secret_word
		if @checking_player.word_guessed?
			puts "Congratulations! #{@guessing_player.name} WINS!"
		else
			puts "#{@guessing_player.name} loses!"
		end
	end
end

class ComputerPlayer
	attr_reader :dictionary, :name, :secret_word, :misses

	def initialize(name)
		@name = name
		@guessed_letters = []
		load_dictionary
	end

	def pick_secret_word
		@misses = 0
		@secret_word = dictionary.sample
		init_check_vars
	end

	def give_secret_length
		@secret_word.length
	end

	def receive_secret_length(length)
		@secret_word_length = length
	end

	def guess
		update_dictionary
		
	end

	def update_dictionary
		@dictionary = @dictionary.select { |word| word.length == @secret_word_length }

	end

	def guess_random
		random_letter = (97 + rand(26)).chr
		while @guessed_letters.include?(random_letter)
			random_letter = (97 + rand(26)).chr
		end
		@guessed_letters << random_letter
		random_letter
	end

	def valid_guess?(guess)
		if @guessed_letters.include?(guess)
			puts "You've guessed that letter!"
			false
		else
			true
		end
	end

	def handle_guess_response(guess)
		@guessed_letters << guess
		if @secret_word.include?(guess)
			puts "#{guess} is correct!"
			indices = find_indices_in_word(guess)
			indices.each { |index| @discovered_word[index] = guess }
		else
			puts "#{guess} is not in my word!"
			@misses += 1
		end
	end

	def display_status
		puts "Word Length: #{@secret_word.length}"
		p @discovered_word.join("")
	end

	def word_guessed?
		@secret_word == @discovered_word.join
	end

	def print_secret_word
		puts "Secret word was #{@secret_word}."
	end

	private

	def init_check_vars
		@discovered_word = Array.new(@secret_word.length) { "_" }
	end

	def find_indices_in_word(guess)
		indices = []
		@secret_word.split("").each_index do |index|
			if @secret_word[index] == guess
				indices << index
			end
		end
		indices
	end

	def load_dictionary
		@dictionary = File.read("dictionary.txt").split("\n")
	end
end

class HumanPlayer
	attr_reader :name, :misses

	def initialize(name)
		@name = name
	end

	def pick_secret_word
		puts "Think of a word for the computer to guess."
		puts "How long is your word?"
		@word_length = gets.chomp.to_i
		init_check_vars
		@misses = 0
	end

	def give_secret_length
		@word_length
	end

	def receive_secret_length(length)
	end

	def guess
		letter = ""
		puts "Guess a letter!"
		letter = gets.downcase.chomp until letter =~ /[a-zA-Z]/
		letter
	end

	def valid_guess?(guess)
		true
	end

	def handle_guess_response(guess)
		puts "If '#{guess}' is in your word, type the positions of the letter in your word (Ex. '1,4,5'). If '#{guess}' is not in your word, type 'n'."
		locations = gets.chomp
		if locations == "n"
			@misses += 1
		else
			indices = locations.split(",")
			indices.map! { |el| el.to_i - 1 }
			indices.each { |index| @discovered_word[index] = guess }
		end
	end

	def word_guessed?
		!@discovered_word.include?("_")
	end

	def display_status
		p @discovered_word.join("")
	end

	def print_secret_word
	end

	private

	def init_check_vars
		@discovered_word = Array.new(@word_length) { "_" }
	end

end


siri = ComputerPlayer.new("Siri")
alpha = ComputerPlayer.new("Alpha")
kush = HumanPlayer.new("Kush")
test_game = Hangman.new(siri,kush)
test_game.play
