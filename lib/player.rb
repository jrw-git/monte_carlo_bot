# encoding: UTF-8

class Player

  attr_reader :symbol

  public

  def initialize(player_symbol)
    @symbol = player_symbol
  end

  def get_move(current_board)
    return get_random_move(current_board)
  end

  def to_s
    return @symbol
  end

  private

  def get_random_move(current_board)
    # need to account for cases where the board is full?
    # shouldn't that never happen since the game is won/lost at that point?
    possible_moves = current_board.get_available_moves
    random_move = possible_moves[Random.rand(possible_moves.size)]
    return random_move
  end

end
