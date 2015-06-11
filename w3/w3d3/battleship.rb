class Board
  attr_reader :grid, :ship_locations, :size
  attr_accessor :counts

  STATUS = { :miss => "O", :hit => "X", :water => "~" }

  def initialize(size)
    @size = size
    @ship_locations = []
    @fire_locations = []
    @counts = {:ships => 5, :misses => 0}
    @counts[:water] = size * size - @counts[:ships]
    @grid = Array.new(size) {Array.new(size) { STATUS[:water] } }
  end

  def [](row,col)
    @grid[row][col]
  end

  def []=(row, col, mark)
    @grid[row][col] = mark
  end

  def display
    @grid.each { |row| p row }
  end

  def populate_grid
    until @ship_locations.count >= @counts[:ships]
      row = Random.new.rand(@size)
      col = Random.new.rand(@size)
      next if @ship_locations.include?([row,col])
      @ship_locations << [row,col]
    end
  end

  def in_range?(row, col)
    (row >= 0 && row < @size) && (col >= 0 && col < @size)? true : false
  end

  def mark_board(row, col)
    if @fire_locations.include?([row, col])
      puts "Already fired here!"
    elsif @ship_locations.include?([row, col])
      @grid[row][col] = STATUS[:hit]
      @counts[:ships] -= 1
      @ship_locations.delete([row, col])
      @fire_locations << [row, col]
    else
      @grid[row][col] = STATUS[:miss]
      @counts[:misses] += 1
      @counts[:water] -= 1
      @fire_locations << [row, col]
    end
  end
end

class Game

  def initialize(board_size = 8)
      @game_board = Board.new(board_size)
      @player1 = HumanPlayer.new
  end

  def play
    @game_board.populate_grid
    welcome_msg
    until game_over?
      play_turn
    end
    end_message
  end

  def welcome_msg
    puts "Welcome to BattleShip!"
    puts "Fire at location (x,y) by entering 'x,y'"
    display_status
  end

  def play_turn
    fire_at = @player1.get_user_input
    until @game_board.in_range?(*fire_at)
      puts "Invalid location. Please enter location within (0-#{@game_board.size-1})x(0-#{@game_board.size-1})."
      fire_at = @player1.get_user_input
    end
    attack(fire_at)
    display_status
  end

  def attack(pos)
    @game_board.mark_board(*pos)
  end

  def display_status
    @game_board.display
    p @game_board.counts
    p @game_board.ship_locations
  end

  def game_over?
    if @game_board.counts[:ships] == 0 || @game_board.counts[:water] == 0
      true
    else
      false
    end
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
  #
  # def initialize
  # end

  def get_user_input
    puts "Where would you like to fire?"
    user_input = gets.chomp.split(",")
    user_input = user_input.map { |el| el.to_i }
    until user_input.length == 2 && user_input.all? { |el| el.class == Fixnum }
      puts "Invalid input. Please enter a valid location (ie. 0,0)"
      user_input = gets.chomp.split(",")
      user_input = user_input.map { |el| el.to_i }
    end
    user_input
  end

  def check_input(input)
    if input == "quit"
    end
  end
end
