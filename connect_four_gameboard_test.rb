require 'minitest/autorun'
require './connect_four_gameboard'

class TestBoard < Minitest::Test

  def setup
    @board = Gameboard.new
  end

  def test_validate_and_move
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    assert_equal result, -1
    result = @board.validate_and_move(1, '1')
    assert_equal result, 1
  end

  def test_get_available_moves
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '1')
    result = @board.validate_and_move(5, '1')
    result = @board.validate_and_move(5, '1')
    result = @board.validate_and_move(5, '1')
    result = @board.validate_and_move(5, '1')
    result = @board.validate_and_move(5, '1')
    result = @board.get_available_moves
    proper_result = [1,2,3,4,6]
    assert_equal result, proper_result
  end

  def test_is_there_a_win
    # less than 7 turns test
    @board = Gameboard.new
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '2')
    win = @board.is_there_a_win?('1')
    assert_equal false, win

    # horizontal test
    @board = Gameboard.new
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(0, '1')
    win = @board.is_there_a_win?('1')
    assert_equal true, win
    # vertical test
    @board = Gameboard.new
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(1, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(2, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(3, '1')
    win = @board.is_there_a_win?('1')
    assert_equal true, win
    # diagonal test #1
    @board = Gameboard.new
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(1, '2')
    result = @board.validate_and_move(1, '1')
    result = @board.validate_and_move(2, '2')
    result = @board.validate_and_move(2, '1')
    result = @board.validate_and_move(2, '1')
    result = @board.validate_and_move(3, '2')
    result = @board.validate_and_move(3, '2')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    win = @board.is_there_a_win?('1')
    assert_equal true, win
    # diagonal test #2
    @board = Gameboard.new
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(2, '2')
    result = @board.validate_and_move(2, '1')
    result = @board.validate_and_move(1, '2')
    result = @board.validate_and_move(1, '1')
    result = @board.validate_and_move(0, '2')
    result = @board.validate_and_move(1, '1')
    result = @board.validate_and_move(6, '2')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '2')
    result = @board.validate_and_move(0, '1')
    win = @board.is_there_a_win?('1')
    assert_equal true, win
  end

  def test_undo_last_move
    @board = Gameboard.new
    result = @board.validate_and_move(3, '1')
    @board.undo_last_move
    assert_equal @board.turn, 1
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    assert_equal result, -1
    @board.undo_last_move
    assert_equal 6, @board.turn
    result = @board.validate_and_move(3, '1')
    assert_equal result, 3
  end

end
