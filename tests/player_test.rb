# encoding: UTF-8

require 'minitest/autorun'
require '../lib/player'

class TestPlayer < Minitest::Test

  def test_initialize
    # make sure symbols get assigned properly
    player = Player.new("Woo")
    assert_equal player.symbol, "Woo"
    player = Player.new(2)
    assert_equal player.symbol, 2
  end

  def test_get_move
    # test random moves in the default player class
    player = Player.new(1)
    (0...100).each do
      move = player.get_move("null board")
      assert_in_delta 0, move, 6
    end
  end

  def to_s
    player = Player.new(1)
    assert_equal 1, player.to_s
  end

end
