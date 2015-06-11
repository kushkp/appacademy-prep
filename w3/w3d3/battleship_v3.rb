#computer player set up
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

  def populate_grid
    until @grid.flatten.count(:ship) == 5
      row = Random.new.rand(@size)
      col = Random.new.rand(@size)
      self[row, col] = :ship
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
    # byebug
    ship_locs_arr = []
    @grid.each_index do |row|
      @grid[row].each_index do |col|
        if self[row, col] == :ship
          ship_locs_arr << [row, col]
        end
      end
    end
    # p ship_locs_arr #for debugging
  end

end

class Game

  def initialize(board_size = 8)
      @game_board = Board.new(board_size)
      @player1 = HumanPlayer.new("Bob")
      @player2 = ComputerPlayer.new
  end

  def play
    @game_board.populate_grid
    welcome_msg
    play_turn(@player2) until game_over?
    end_message
  end

  def welcome_msg
    puts "Welcome to BattleShip!"
    puts "Fire at location (x,y) by entering 'x,y'"
    display_status
  end

  def play_turn(player)
    fire_at = player.get_input
    until @game_board.in_range?(*fire_at)
      puts "Invalid location. Please enter location within (0-#{@game_board.size-1})x(0-#{@game_board.size-1})."
      fire_at = player.get_user_input
    end
    attack(fire_at)
    display_status
  end

  def attack(pos)
    @game_board.mark_board(*pos)
  end

  def display_status
    @game_board.display
    @game_board.print_counts
    @game_board.ship_locations #for debugging
  end

  def game_over?
    @game_board.counts[:ships] == 0 ? true : false
  end

  def end_message
    if @game_board.counts[:ships] == 0
      puts "Congrats, you win!"
    else
      puts "You lose :("
    end
  end
end

class HumanPlayer
  def initialize(name)
    @name = name
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
end

class ComputerPlayer
  def initialize
    @guesses = Set.new
  end

  def get_input
    random_pick = [Random.new.rand(8), Random.new.rand(8)]
    while @guesses.include?(random_pick)
      random_pick = [Random.new.rand(8), Random.new.rand(8)]
    end
    puts "random pick: #{random_pick}"
    @guesses << random_pick
    random_pick
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
