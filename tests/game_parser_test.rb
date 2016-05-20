# encoding: UTF-8

require 'minitest/autorun'
require '../game_parser'

class TestGameParser < Minitest::Test

  def teardown
    puts '-' * 50
    puts "NOTE:"
    puts "You will see a few ERROR: messages in this test. This is normal and expected."
    puts "Testing is complete as long as all assertions pass and there are no failures."
    puts "The errors are automatically printed out when garbage instructions are passed."
    puts "This is done as part of the testing process of course"
  end

  def test_process_commands
    parser = BotParser.new
    s1 = "settings timebank 10000"
    s2 = "settings time_per_move 500"
    s3 = "settings player_names player1,player2"
    s4 = "settings your_bot player1"
    s5 = "settings your_botid 1"
    s6 = "settings field_columns 7"
    s7 = "settings field_rows 6"
    u1 = "update game round 1"
    # u2 = "Bono"
    u2 = "update game field 0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0"
    a1 = "action move 10000"
    result = parser.process_line_of_commands(s1)
    assert_equal true, result
    result = parser.process_line_of_commands(s2)
    assert_equal true, result
    result = parser.process_line_of_commands(s3)
    assert_equal true, result
    result = parser.process_line_of_commands(s4)
    assert_equal true, result
    result = parser.process_line_of_commands(s5)
    assert_equal true, result
    result = parser.process_line_of_commands(s6)
    assert_equal true, result
    result = parser.process_line_of_commands(s7)
    assert_equal true, result
    result = parser.process_line_of_commands(u1)
    assert_equal true, result
    result = parser.process_line_of_commands(u2)
    assert_equal true, result
    result = parser.process_line_of_commands(a1)
    assert_equal true, result

    bad_string = "some random junk"
    result = parser.process_line_of_commands(bad_string)
    assert_equal false, result
    bad_string = "settings random junk"
    result = parser.process_line_of_commands(bad_string)
    assert_equal false, result
    bad_string = "update random junk"
    result = parser.process_line_of_commands(bad_string)
    assert_equal false, result
    bad_string = "action random junk"
    result = parser.process_line_of_commands(bad_string)
    assert_equal false, result
    bad_string = "action move junk"
    result = parser.process_line_of_commands(bad_string)
    assert_equal false, result

  end

end
