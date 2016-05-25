# encoding: UTF-8

require_relative "lib/connect_four_gameboard"
require_relative "lib/player"
require_relative "lib/human_player"
require_relative "lib/monte_carlo_player"

class GameEngine

  public

  def initialize(player_one, player_two, board_string = "default", turn = 1)
    if board_string == "default"
      @current_board = Gameboard.new
    else
      @current_board = Gameboard.new(board_string, turn)
    end
    @current_player = player_one
    @next_player = player_two
  end

  def run_game
    end_of_game = 0
    until end_of_game != 0
      puts "Turn #{@current_board.turn}, current player #{@current_player}"
      puts self.to_s
      end_of_game = get_turn_from_player(@current_player)
      end_turn if end_of_game == 0
    end
    if end_of_game == 1
      display_end_of_game
    else
      display_tied_game
    end
  end

  def to_s
    @current_board.to_s
  end

  private

  def display_tied_game
    puts
    puts "-"*50
    puts "Tied game, no more possible moves!"
    puts "Final Gameboard:"
    puts self.to_s
    puts "Good playing, both players!"
    puts "-"*50
    puts "Exiting game..."
  end

  def display_end_of_game
    puts
    puts "-"*50
    puts "We found a winner!"
    puts "Player #{@current_player} just got four in a row!"
    puts "Final Gameboard:"
    puts self.to_s
    puts "Congrats Player #{@current_player}, you've won!"
    puts "-"*50
    puts "Exiting game..."
  end

  def get_turn_from_player(active_player)
    desired_move = active_player.get_move(@current_board)
    if desired_move == 'u'
      @current_board.undo_last_move
      return 0
    end
    validated_move = @current_board.validate_and_move(desired_move, active_player)
    if validated_move == -1
      handle_inappropriate_input(desired_move, active_player)
    end
    return @current_board.is_there_a_win?(active_player)
  end

  def handle_inappropriate_input(move, player)
    puts "Oops, looks like #{move} wasn't a valid column number. Try again."
    get_turn_from_player(player)
  end

  def end_turn
    @last_player = @current_player
    @current_player = @next_player
    @next_player = @last_player
  end

end

# only run this code if we are executing THIS file specifically
# ie, don't run it when performing tests or if it's included otherwise
if __FILE__ == $0
  test_board_string = "0,2,0,0,0,0,2;0,1,0,0,0,0,1;0,2,0,0,0,0,2;0,1,0,0,0,0,1;0,2,0,0,0,0,2;0,1,0,0,0,0,1"
  player_one = HumanPlayer.new('1')
  player_two = HumanPlayer.new('2')
  #player_two = MonteCarloPlayer.new('2')
  our_game = GameEngine.new(player_one, player_two)
  our_game.run_game
end
