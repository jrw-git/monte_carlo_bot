# encoding: UTF-8

require 'minitest/autorun'
require '../connect_four_engine'

class TestEngine < Minitest::Test

  def setup
    player_one = MonteCarloPlayer.new('1')
    player_two = MonteCarloPlayer.new('2')
    our_game = GameEngine.new(player_one, player_two)
  end

  def test_run_game
    # hmm need to think on how I can properly test the game loop
    #our_game.run_game
    assert_equal "To Implement", "Testing Main Game Loop"
  end


end
