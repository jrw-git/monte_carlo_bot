# encoding: UTF-8

require 'minitest/autorun'
require '../lib/connect_four_gameboard'

class TestBoard < Minitest::Test

  def setup
    @board = Gameboard.new
  end

  def test_initialize_gameboard_with_aigames_string
    # test that we can initialize with theaigames board formatted string
    @board = Gameboard.new("0,2,0,0,0,0,2;0,1,0,0,0,0,1;0,2,0,0,0,0,2;0,1,0,0,0,0,1;0,2,0,0,0,0,2;0,1,0,0,0,0,1", 10)
    assert_equal @board.turn, 10
    result = @board.validate_and_move(1, '1')
    assert_equal -1, result
    result = @board.validate_and_move(6, '1')
    assert_equal -1, result
    result = @board.validate_and_move(0, '2')
    assert_equal 0, result
    result = @board.validate_and_move(4, '1')
    assert_equal 4, result
  end

  def test_to_ai_games
    # test that we output a string conforming with theaigames board format
    # both from a clean board and from a board initializd with aigames string
    @board = Gameboard.new
    clean_board_string = "0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0"
    assert_equal clean_board_string, @board.to_ai_games
    partly_filled_board_string = "0,2,0,0,0,0,2;0,1,0,0,0,0,1;0,2,0,0,0,0,2;0,1,0,0,0,0,1;0,2,0,0,0,0,2;0,1,0,0,0,0,1"
    @board = Gameboard.new(partly_filled_board_string, 10)
    assert_equal partly_filled_board_string, @board.to_ai_games
  end

  def test_validate_and_move
    # test that moves are made and that full columns can't be moved into
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
    # test that full columns are not returned as available moves
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
    # need to move at least 7 times before a win is even checked for
    @board = Gameboard.new
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(5, '2')
    win = @board.is_there_a_win?('1')
    assert_equal false, win

    # horizontal test of win detection
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
    # vertical test of win detection
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
    # diagonal test #1 of win detection
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
    # diagonal test #2 of win detection
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

  def test_is_there_a_tie
    @board = Gameboard.new
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '2')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '2')
    result = @board.validate_and_move(0, '1')
    result = @board.validate_and_move(0, '2')
    result = @board.validate_and_move(1, '1')
    result = @board.validate_and_move(1, '2')
    result = @board.validate_and_move(1, '1')
    result = @board.validate_and_move(1, '2')
    result = @board.validate_and_move(1, '1')
    result = @board.validate_and_move(1, '2')
    result = @board.validate_and_move(2, '1')
    result = @board.validate_and_move(2, '2')
    result = @board.validate_and_move(2, '1')
    result = @board.validate_and_move(2, '2')
    result = @board.validate_and_move(2, '1')
    result = @board.validate_and_move(2, '2')
    result = @board.validate_and_move(4, '1')
    result = @board.validate_and_move(4, '2')
    result = @board.validate_and_move(4, '1')
    result = @board.validate_and_move(4, '2')
    result = @board.validate_and_move(4, '1')
    result = @board.validate_and_move(4, '2')
    result = @board.validate_and_move(5, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(5, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(5, '1')
    result = @board.validate_and_move(5, '2')
    result = @board.validate_and_move(6, '1')
    result = @board.validate_and_move(6, '2')
    result = @board.validate_and_move(6, '1')
    result = @board.validate_and_move(6, '2')
    result = @board.validate_and_move(6, '1')
    result = @board.validate_and_move(6, '2')
    result = @board.validate_and_move(3, '2')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '2')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '2')
    assert_equal(@board.is_there_a_tie?, false)
    result = @board.validate_and_move(3, '1')
    assert_equal @board.turn, 43
    assert_equal result, 3
    assert_equal(@board.is_there_a_tie?, true)
    result = @board.validate_and_move(3, '1')
    assert_equal result, -1
    assert_equal @board.turn, 43
    assert_equal(@board.is_there_a_tie?, true)
  end

  def test_undo_last_move
    @board = Gameboard.new
    # test that when we undo a move, the turn counter is decremented
    result = @board.validate_and_move(3, '1')
    assert_equal @board.turn, 2
    @board.undo_last_move
    assert_equal @board.turn, 1
    # test that an undo lets us move into a previously full column
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    result = @board.validate_and_move(3, '1')
    assert_equal result, 3
    result = @board.validate_and_move(3, '1')
    assert_equal result, -1
    @board.undo_last_move
    assert_equal 6, @board.turn
    result = @board.validate_and_move(3, '1')
    assert_equal result, 3
  end

  def test_to_s
    # test that a partly filled board matches what it 'should' look like
    partly_filled_board_string = "0,2,0,0,0,0,2;0,1,0,0,0,0,1;0,2,0,0,0,0,2;0,1,0,0,0,0,1;0,2,0,0,0,0,2;0,1,0,0,0,0,1"
    @board = Gameboard.new(partly_filled_board_string, 10)
    proper_string = "\n0 1 2 3 4 5 6\n-------------\n0 2 0 0 0 0 2\n0 1 0 0 0 0 1\n0 2 0 0 0 0 2\n0 1 0 0 0 0 1\n0 2 0 0 0 0 2\n0 1 0 0 0 0 1\n-------------\n"
    assert_equal proper_string, @board.to_s
    # test that a fresh board is aligned and all 0's etc
    @board = Gameboard.new
    proper_string = "\n0 1 2 3 4 5 6\n-------------\n0 0 0 0 0 0 0\n0 0 0 0 0 0 0\n0 0 0 0 0 0 0\n0 0 0 0 0 0 0\n0 0 0 0 0 0 0\n0 0 0 0 0 0 0\n-------------\n"
    assert_equal proper_string, @board.to_s
  end

end
