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
