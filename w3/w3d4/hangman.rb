class Hangman
	def initialize(guessing_player, checking_player)
		@guessing_player = guessing_player
		@checking_player = checking_player
		@turns = 0
	end

	def play
		@checking_player.pick_secret_word
		until game_over?
			play_turn
		end
		print_end_message
	end

	private

	def play_turn
			@checking_player.display_status
			puts "Turn: #{@turns}"
			guess = @guessing_player.guess
			until @checking_player.valid_guess?(guess)
				guess = @guessing_player.guess
			end
			@checking_player.handle_guess_response(guess)
			@turns += 1
	end

	def game_over? #should this belong to player classes?
		@checking_player.word_guessed? || @turns == 15
	end

	def print_end_message #should this belong to player classes?
		puts "The word was #{@checking_player.secret_word}." #then we can reference @secret_word variable from within the object
		if @turns == 15
			puts "You lose!"
		else
			puts "Congratulations! You WIN!"
		end
	end
end

class ComputerPlayer
	attr_reader :dictionary, :secret_word

	def initialize
		load_dictionary
	end

	def pick_secret_word
		@secret_word = dictionary.sample
		init_check_vars
	end

	def receive_secret_length
	end

	def guess
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
		end
	end

	def display_status
		p @discovered_word.join("")
	end

	def word_guessed?
		@secret_word == @discovered_word.join #("")
	end

	private

	def init_check_vars
		@discovered_word = Array.new(@secret_word.length) { "_"}
		@guessed_letters = []
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
	def initialize
	end

	def pick_secret_word
	end

	def receive_secret_length
	end

	def guess
		letter = ""
		puts "Guess a letter!"
		letter = gets.downcase.chomp until letter =~ /[a-zA-Z]/
		letter
	end

	def valid_guess?(guess)
	end

	def handle_guess_response
	end
end


siri = ComputerPlayer.new
kush = HumanPlayer.new
test_game = Hangman.new(kush,siri)
test_game.play
