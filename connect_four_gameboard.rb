class Gameboard

#attr_reader :board, :height, :width, :turns, :last_move_array

attr_reader :turn

  DefaultSymbol = 0
  DefaultHeight = 6
  DefaultWidth = 7

  public

  def initialize(turn = 1, board_string = "default")
    @height = DefaultHeight
    @width = DefaultWidth
    # fill the board with all blanks (DefaultSymbol here)
    if board_string == "default"
      @board = Array.new(@height) { Array.new(@width, DefaultSymbol) }
    else
      @board = get_gameboard_from_string(board_string)
    end
    @turn = turn
    @last_move_array = Array.new
  end

  def validate_and_move(desired_move, active_player)
    # will return -1 if invalid
    # otherwise makes the move and returns # of column moved in
    # using Integer, an exception is thrown if alpha characters are entered
    begin
      desired_move = Integer(desired_move)
    rescue
      return -1
    end
    # move must be between 0 and 6 inclusive
    if desired_move > 6 || desired_move < 0
      return -1
    end
    # column selected must have an empty slot
    return -1 if !is_location_empty?(5, desired_move)
    # move is valid if it passes all these tests
    make_move(desired_move, active_player)
    return desired_move
  end

  def get_available_moves
    coord_array = Array.new
    (0...@width).each do |column_number|
      coord_array.push(column_number) if is_location_empty?(5, column_number)
    end
    return coord_array
  end

  def to_s
    puts "0 1 2 3 4 5 6"
    puts "-------------"
    @board.each_index do |height_index|
      @board[height_index].each_index do |width_index|
        backwards_height = @height - height_index - 1
        #print "#{@board[backwards_height][width_index]} "
        print "#{@board[backwards_height][width_index]} (#{backwards_height},#{width_index}) "
      end
      puts
    end
    puts "-------------"
  end

  def is_there_a_win?(active_player)
    # we check the squares connecting in a line from last move
    # ie the horizontal/vertical and the two diagonals
    return false if @turn < 7
    last_height = @last_move_array[-1]["height"]
    last_width = @last_move_array[-1]["width"]
    return true if check_horizontal_and_vertical(last_height, last_width, active_player)
    return true if check_diagonal_one(last_height, last_width, active_player)
    return true if check_diagonal_two(last_height, last_width, active_player)
    return false # if we haven't found a win yet, there is no win to be found
  end

  def undo_last_move
    last_move = @last_move_array.pop
    last_height = last_move["height"]
    last_width = last_move["width"]
    @board[last_height][last_width] = DefaultSymbol
    @turn -= 1
    return last_width
  end

  def to_ai_games
    ai_games_string = ""
    (0...@height).each do |h|
      true_h = 5 - h
      (0...@width).each do |w|
        ai_games_string += @board[true_h][w].to_s + ","
      end
      ai_games_string.chop!
      ai_games_string += ';'
    end
    ai_games_string.chop!
    return ai_games_string
  end

  private

  def get_gameboard_from_string(string)
    # eg 0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,2,0,1,0,0,0;0,2,0,1,0,0,0
    board_array = string.split(";")
    board_array.reverse!
    new_board = board_array.map { |string| string.split(",") }
    return new_board
  end

  def make_move(column_number, player_number)
    h = get_height_of_first_empty_location_in_column(column_number)
    place_piece(h, column_number, player_number)
    @turn += 1
    return column_number
  end

  def check_horizontal_and_vertical(last_height, last_width, active_player)
    # check horizontal from the last move
    win_test = ""
    (0...@width).each do |w|
      win_test += @board[last_height][w].to_s
    end
    return true if check_string_for_four_in_a_row(win_test, active_player)
    # check vertical from last move
    win_test = ""
    (0...@height).each do |h|
      win_test += @board[h][last_width].to_s
    end
    return true if check_string_for_four_in_a_row(win_test, active_player)
  end

  def check_diagonal_one(last_height, last_width, active_player)
    # checking diagonal #1.. descending from left to right
    win_test = ""
    # first find a starting point
    # we look for the lowest connecting diagonal (descending right)
    if last_height == 0 || last_width == 6
      start_height = last_height
      start_width = last_width
    else
      solution_found = false
      start_height = last_height
      start_width = last_width
      until start_height == 0 || start_width == 6
        start_height -= 1
        start_width += 1
      end
    end
    # now that we've found the lowest point, start climbing left
    # this gets us a list of all the pieces in that diagonal row
    all_rows_added = false

    while start_height <= 5 && start_width >= 0
      win_test += @board[start_height][start_width].to_s
      start_height += 1
      start_width -= 1
    end
    return true if check_string_for_four_in_a_row(win_test, active_player)
  end

  def check_diagonal_two(last_height, last_width, active_player)
    # checking diagonal #2.. ascending from left to right
    win_test = ""
    # again we are searching for the lowest/widest part of the diagonal
    # we use the last piece placed to find the diagonal
    # then add up everything on that diagonal
    if last_height > last_width
      start_height = last_height - last_width
      start_width = 0
    elsif last_height < last_width
      start_height = 0
      start_width = last_width - last_height
    elsif last_height == last_width
      start_height = 0
      start_width = 0
    else
      puts "You shouldn't ever see this... error in is_there_a_win"
    end
    # now that we've got our start point, add the diagonal up
    while start_height <= 5 && start_width <= 6
      win_test += @board[start_height][start_width].to_s
      start_width += 1
      start_height += 1
    end
    return true if check_string_for_four_in_a_row(win_test, active_player)
  end

  def get_height_of_first_empty_location_in_column(column_number)
    # we know that there is an empty spot in this column
    # it's been checked with is_move_valid
    (0...@height).each do |height_index|
      return height_index if is_location_empty?(height_index, column_number)
    end
  end

  def is_location_empty?(h, w)
      return true if @board[h][w] == DefaultSymbol
      return false
  end

  def place_piece(height, width, player_number)
    @last_move_array.push({"height" => height, "width" => width, "player" => player_number})
    @board[height][width] = player_number
  end

  def check_string_for_four_in_a_row(string_to_check, active_player)
    search_string = "#{active_player}#{active_player}#{active_player}#{active_player}"
    win_check = string_to_check.scan(search_string)
    if win_check.size >= 1
      return true
    end
    win_check = string_to_check.scan(search_string)
    if win_check.size >= 1
      return true
    end
    return false
  end

end
