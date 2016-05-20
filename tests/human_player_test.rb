# encoding: UTF-8

require 'minitest/autorun'
require '../lib/human_player'

class TestHumanPlayer < Minitest::Test

  def test_initialize
    # make sure symbols get assigned properly
    player = HumanPlayer.new("Woo")
    assert_equal player.symbol, "Woo"
    player = HumanPlayer.new(2)
    assert_equal player.symbol, 2
  end

  def test_get_move
    assert_equal "Need to Implement", "Testing Input"
  end

  def to_s
    player = HumanPlayer.new(1)
    assert_equal 1, player.to_s
  end

end
