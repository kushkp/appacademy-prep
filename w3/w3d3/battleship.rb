#Goad: enable 2p game
require 'byebug'
require 'set'

class Board
  attr_reader :grid, :ship_locations, :size
  attr_accessor :counts

  STATUS = { :miss => "O", :hit => "X", :water => "~" , :ship => "~"}

  def initialize(size)
    @size = size
    @counts = {:ships => 5, :misses => 0}
    @grid = Array.new(size) { Array.new(size) { :water } }
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, val)
    @grid[row][col] = val
  end

  def display
    p "  #{(0...@size).to_a.join(" ")}"
    @grid.each_with_index do |row, index|
       p display_row(row, index)
    end
  end

  def display_row(row, index)
    chars = row.map { |el| STATUS[el] }.join(" ")
    "#{index} #{chars}"
  end

  def populate_grid(locations = nil)
    if locations.nil?
      until @grid.flatten.count(:ship) == 5
        row = rand(@size)
        col = rand(@size)
        self[row, col] = :ship
      end
    else
      locations.each { |row, col| self[row.to_i, col.to_i] = :ship }
    end
  end

  def print_counts
    ships_remaining = @grid.flatten.count(:ship)
    misses = @grid.flatten.count(:miss)
    puts "Ships remaining: #{ships_remaining}, Misses: #{misses}"
  end

  def in_range?(row, col)
    (row >= 0 && row < @size) && (col >= 0 && col < @size)? true : false
  end

  def mark_board(row, col)
    case self[row, col]
    when :hit, :miss
      puts "You already fired here!"
    when :water
      self[row, col] = :miss
      @counts[:misses] += 1
    when :ship
      self[row, col] = :hit
      @counts[:ships] -= 1
    end
  end

  def ship_locations #only for debugging
    ship_locs_arr = []
    @grid.each_index do |row|
      @grid[row].each_index do |col|
        if self[row, col] == :ship
          ship_locs_arr << [row, col]
        end
      end
    end
    p ship_locs_arr #for debugging
  end
end

class Game
  def initialize(board_size = 4)
      @player1 = HumanPlayer.new("PeeWee", 4)
      @player2 = ComputerPlayer.new("Naval Commander", 4)
      @players = [@player1, @player2]
      @this_player = @player2
      @other_player = @player1
  end

  def play
    @players.each {|player| player.setup_board}
    welcome_message
    until game_over?
      change_turn
      play_turn(@this_player)
    end
    end_message
  end

  def welcome_message
    puts "Welcome to BattleShip!"
    puts "Fire at location (x,y) by entering 'x,y'"
  end

  def change_turn
    @this_player, @other_player = other_player, other_player
  end

  def other_player
    @this_player == @player1 ? @player2 : @player1
  end

  def play_turn(player)
    display_board
    puts "#{player.name}'s Turn:'"
    fire_at = player.get_input
    p fire_at
    until valid_move?(*fire_at)
      puts "Invalid location. Please enter location within (0-#{@other_player.board.size-1})x(0-#{@other_player.board.size-1})."
      fire_at = player.get_input
    end
    attack(fire_at)
    display_board
    display_status
  end

  def valid_move?(row, col)
    if @other_player.board.in_range?(row, col) && (@other_player.board[row, col] == :water || @other_player.board[row, col] == :ship)
      true
    else
      false
    end
  end

  def attack(pos)
    @this_player.board.mark_board(*pos)
  end

  def display_board
    @this_player.board.display
  end

  def display_status
    @this_player.board.print_counts
    @this_player.board.ship_locations #for debugging
    puts "\n"
  end

  def game_over?
    @this_player.board.counts[:ships] == 0 ? true : false
  end

  def end_message
    change_turn unless @this_player.board.counts[:ships] == 0
    puts "Congrats, #{@this_player.name} wins!"
  end
end

class HumanPlayer
  attr_reader :name
  attr_accessor :board

  def initialize(name, board_size)
    @name = name
    @board = Board.new(board_size)
  end

  def get_input
    puts "Where would you like to fire?"
    user_input = gets.chomp.split(",")
    until valid_input?(user_input)
      puts "Invalid input. Please enter a valid location (ie. 0,0)"
      user_input = gets.chomp.split(",")
    end
    convert_input(user_input)
  end

  def convert_input(input_arr)
    input_arr.map { |el| el.to_i }
  end

  def valid_input?(input_arr)
    digits = %w[0 1 2 3 4 5 6 7 8 9]
    if input_arr.length == 2 && input_arr.all? { |el| digits.include?(el) }
      true
    else
      false
    end
  end

  def setup_board
    puts "Where would you like to place your 5 ships?"
    puts "Enter locations like '1 2, 2 3, 0 0, etc..."
    locations = []
    until locations.length == 5
      input = gets.chomp.split(",")
      input.map! { |string| string.strip}
      locations = []
      input.each { |string| locations << string.scan(/\d+/) }
    end
    @board.populate_grid(locations)
  end
end

class ComputerPlayer
  attr_reader :name
  attr_accessor :board

  def initialize(name, board_size)
    @board = Board.new(board_size)
    @board_size = board_size
    @name = name
    @guesses = Set.new
  end

  def get_input
    random_pick = [rand(@board_size), rand(@board_size)]
    while @guesses.include?(random_pick)
      random_pick = [(@board_size), rand(@board_size)]
    end
    puts "random pick: #{random_pick}"
    @guesses << random_pick
    random_pick
  end

  def setup_board
    @board.populate_grid()
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
