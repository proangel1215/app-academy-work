require_relative 'display'
require_relative 'human_player'
require_relative 'computer_player'
require 'byebug'

class Game 

    attr_reader :board, :computer, :computer_end_pos, :computer_piece, :computer_start_pos, :current_player, :display, :player
    attr_accessor :starting_piece 

    def initialize(name1)
        introduction 
        @board = Board.new
        @display = Display.new(board)
        @starting_piece = nil 
        @player = HumanPlayer.new(name1, :white)
        @computer = ComputerPlayer.new('Computer', :black, board) 
        @computer_piece = nil 
        @computer_start_pos = nil 
        @computer_end_pos = nil 
        @current_player = player
    end 

    def play 
        until board.checkmate?(current_player.color)
            if current_player == player 
                player_move
            else 
                computer_move 
            end 
            check_prompt
            swap_turn
            #debugger 
        end 
        result
    end 

    def player_move 
        move_complete = false 
        while !move_complete
            start_position = get_start_position 
            @starting_piece = board[start_position.first, start_position.last] 
            end_position = get_cursor_selection(select_position_prompt)
            next if end_position == start_position
            print_board
            #debugger 
            move_complete = true if board.move_piece(start_position, end_position) 
        end 
    end 

    def computer_move
        @computer_piece, @computer_start_pos, @computer_end_pos = computer.move 
    end 

    def computer_move_prompt
        puts "Black moved their #{computer_piece} from #{display.letter_hash[computer_start_pos.first]}#{computer_start_pos.last} to #{display.letter_hash[computer_end_pos.first]}#{computer_end_pos.last}." if !computer.at_start && !board.checkmate?(computer.color)
    end 

    private 

    def introduction 
        puts "Welcome to Chess!"
        puts "For chess instructions, please visit https://en.wikipedia.org/wiki/Rules_of_chess"
        puts "Use space or enter to select pieces and squares."
        puts "Press return/enter to begin."
        gets 
    end 

    def select_piece_prompt 
        "#{current_player.name}, select a piece."
    end 

    def select_position_prompt
        "#{current_player.name}, select a square to move the #{starting_piece.color.capitalize} #{starting_piece.class}."
    end 

    def check_prompt
        puts "#{current_player.color.capitalize} is in check." if board.in_check?(current_player.color)
    end 

    #method lets player move cursor through board until they hit enter or space 
    def get_cursor_selection(prompt)
        valid_cursor_selection = false

        while !valid_cursor_selection
            print_board
            check_prompt
            puts prompt
            cursor_selection = current_player.make_move(display) 
            valid_cursor_selection = true if cursor_selection.is_a?(Array)
        end 

        cursor_selection
    end 

    #method returns the starting position of a piece 
    def get_start_position  
        valid_start = false 
 
        while !valid_start
            start_position = get_cursor_selection(select_piece_prompt)

            if board.null_piece?(start_position.first, start_position.last)
                print_board
                puts "That is not a piece."
                display.cursor.toggle_selected
                board.prompt_to_continue_move
            elsif board.piece_color(start_position) != current_player.color
                print_board
                puts "That isn't your color. Please select a #{current_player.color.capitalize} piece."
                display.cursor.toggle_selected
                board.prompt_to_continue_move
            else 
            #elsif !board.null_piece?(start_position.first, start_position.last)  
                valid_start = true   
            end 
        end 

        start_position
    end 

    def other_player(current_player)
        current_player == player ? computer : player
    end 

    def swap_turn 
        @current_player = other_player(current_player)
    end 

    def result 
        winner = other_player(current_player)
        loser = current_player 
        print_board
        puts "#{loser.color.capitalize} is in checkmate. #{winner.name} wins. #{loser.name} loses."
    end 

    def print_board 
        clear
        display.render 
        computer_move_prompt
    end 

    def clear 
        system("clear")
    end 

end 