require_relative 'slideable'
require 'byebug'

class Piece 

    attr_reader :color, :position, :symbol 
    attr_accessor :board
    
    def initialize(color, symbol, position, board)
        @color = color
        @symbol = symbol 
        @position = position
        @board = board 
    end 

    def [](row, col)
        board[row][col]
    end 

    def position=(new_position)
        @position = new_position
    end 

    def opponent_color
        if color == :white 
            :black 
        else 
            :white 
        end 
    end  

    def get_opponent_king_position
        board.find_king(opponent_color).position 
    end 

    def move_into_check?(end_pos)
        board_copy = board.duplicate 
        board_copy.move_piece!(position, end_pos)
        board_copy.in_check?(color)
    end 

    def moves 
        all_moves = []
        move_dirs.each { |move_dir| all_moves += move_dir }
        all_moves
    end 

    def valid_moves 
        valid_squares = []
        moves.each { |square| valid_squares << square if !move_into_check?(square) } 
        valid_squares
    end 
    
    private 

    def get_row_col(position)
        [position.first, position.last]
    end 

    def square_has_same_color_piece?(row, col)
        self.color == board[row, col].color 
    end 

    def square_has_different_color_piece?(row, col, opponent_color)
        opponent_color == board[row, col].color 
    end 

    def square_occupied?(position)
        board[position.first, position.last].class != NullPiece
    end 

    def inspect 
        { 'symbol' => symbol, 'color' => color, 'position' => position }.inspect 
    end 

end 