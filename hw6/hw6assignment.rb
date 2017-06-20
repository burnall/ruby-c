# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece

  # class array holding all the pieces and their rotations
  All_My_Pieces = [
    # Shape:
    # **
    # ***
    rotations([[-1, 0], [0, 0], [1, 0], [-1, 1], [0, 1]]),

    # Shape:
    # *****
    [[[0, 0], [-1, 0], [1, 0], [-2, 0], [2, 0]],
    [[0, 0], [0, 1], [0, 2], [0, -2], [0, -1]]],

    # Shape:
    # *
    # **
    rotations([[0, 0], [1, 0], [0, 1]])
  ].concat(All_Pieces)

  Cheat_Piece = [[[0, 0]]]

  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  def self.next_cheat_piece (board)
    MyPiece.new(Cheat_Piece, board)
  end

end

class MyBoard < Board

  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    @going_to_cheat = false
  end

  def next_piece
    if @going_to_cheat
      @current_block = MyPiece.next_cheat_piece(self)
    else
      @current_block = MyPiece.next_piece(self)
    end
    @going_to_cheat = false
    @current_pos = nil
  end

  def flip
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.length-1)).each{|index|
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  def cheat
    if @score >= 100 && !@going_to_cheat
      @going_to_cheat = true
      @score -= 100
      @game.update_score
    end
  end
end

class MyTetris < Tetris

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', proc {@board.flip})
    @root.bind('c', proc {@board.cheat})
  end
end


