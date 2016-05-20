# encoding: UTF-8

require_relative "player"

# difficult to test due to io

class HumanPlayer < Player

  public

  def get_move(current_board)
    possible_moves = current_board.get_available_moves
    print user_message(possible_moves)
    return grab_input
  end

  private

  def user_message(possible_moves)
    string_to_display = "\nEnter the column where you want to place a piece (0-6)\n"
    string_to_display += "Available moves are #{possible_moves}\n"
    string_to_display += "Your move?: "
    return string_to_display
  end

  def grab_input
    return gets.chomp
  end

end
