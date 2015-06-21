require 'byebug'
class Game
  attr_reader :board, :mark_list

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board = Board.new
    @turn = @player1
    @mark_list = { @player1 => :x, @player2 => :o }
  end

  def play
    until won?
      player_turn
      change_turn
    end
    winner_msg
  end

  def change_turn
    if @turn == @player1
      @turn = @player2
    else
      @turn = @player1
    end
  end

  def player_turn # @turn player make move
    @board.print_board
    pos = @turn.pick_move(board)
    until valid_move(pos)
      pos = @turn.pick_move(board)
    end
    board.place_mark(pos, @mark_list[@turn])
  end

  def valid_move(pos)
    pos.all?{ |coord| coord.between?(0,2) } && board[*pos] == nil
  end

  def won?
    # puts "winner: #{winner}" #for debugging
    winner == nil ? false : true
  end

  def winner
    answer = []
    @mark_list.values.each do |mark|
      if board.rows.any? { |row| row == [mark, mark, mark] }
        answer << mark
      elsif board.cols.any? { |col| col == [mark, mark, mark] }
        answer << mark
      elsif board.diags.any? { |diag| diag == [mark, mark, mark] }
        answer << mark
      end
    end
    answer == [] ? nil : answer
  end

  def winner_msg
    winning_player = winner == :x ? @player1 : @player2
    puts "Congrats! #{winning_player.name} wins!"
  end

end

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(3) { Array.new(3) }
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, mark)
    @grid[row][col] = mark
  end

  def rows
    @grid.map { |row| row }
  end

  def cols
    @grid.transpose.map { |row| row }
  end

  def diags
    down_diag = [@grid[0][0], @grid[1][1], @grid[2][2]]
    up_diag = [@grid[0][2], @grid[1][1], @grid[2][0]]
    [down_diag, up_diag]
  end

  def empty?(pos)
    self[*pos] == nil
  end

  def place_mark(pos,mark)
    self[*pos] = mark
  end

  def print_board
    @grid.each { |row| p row }
  end
end

class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def pick_move(board)
    puts "Enter location where you want to move. (Ex. '0,0' puts mark in top left corner)"
    user_input = [-1,-1]
    # until user_input.all? { |coord| coord.ord.between?(48,50) }
      user_input = gets.chomp.split(",")
      # puts user_input
    # end
    user_input.map { |num| num.to_i }
    #returns array of pos [x,y]
  end


end

class ComputerPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def pick_move(board)
    #pick smart
    if



      answer = []
      @mark_list.values.each do |mark|
        if board.rows.any? { |row| row == [mark, mark, mark] }
          answer << mark
        elsif board.cols.any? { |col| col == [mark, mark, mark] }
          answer << mark
        elsif board.diags.any? { |diag| diag == [mark, mark, mark] }
          answer << mark
        end
      end
      answer == [] ? nil : answer
    end

    #or else
    pick_random
  end

  private

  def pick_random
    [rand(3),rand(3)]
  end
end

p1 = HumanPlayer.new("kush")
p2 = ComputerPlayer.new("siri")
test_game = Game.new(p1,p2)
test_game.play
