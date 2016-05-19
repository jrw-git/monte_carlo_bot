
class HumanPlayer < Player

  public
  
  def get_human_input(current_board)
    puts "Enter the column where you want to place a piece (0-6): "
    puts "Available moves: #{current_board.get_available_moves}"
    print "Your move?: "
    move = gets.chomp
    if move == 'u'
      # request an undo?!
    end
    # error handling is done by the game engine not the player class
    return move
  end

  def get_move(current_board)
    return get_human_input(current_board)
  end

end
