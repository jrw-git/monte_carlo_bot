# encoding: UTF-8

class Player

  attr_reader :symbol

  public

  def initialize(player_symbol)
    @symbol = player_symbol
  end

  def get_move(current_board)
    return Random.rand(7)
  end

  def to_s
    return @symbol
  end

end
