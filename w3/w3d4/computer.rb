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


#97 - 122
