require 'minitest/autorun'
require './connect_four_engine'

class TestBoard < Minitest::Test

  def setup
    player_one = MonteCarloPlayer.new('1')
    player_two = MonteCarloPlayer.new('2')
    our_game = GameEngine.new(player_one, player_two)
  end

  def test_run_game
    our_game.run_game
  end


end
