# encoding: UTF-8

require_relative "player"

class MonteCarloPlayer < Player

  attr_reader :symbol

  public

  def initialize(player_symbol)
    @symbol = player_symbol
  end

  def get_move(current_board)
    # get list of all possible moves
    best_move = evaluate_all_moves(current_board)
    puts "Best move found: #{best_move}"
    return best_move
  end

  private

  def evaluate_all_moves(current_board)
    possible_moves = current_board.get_available_moves
    if possible_moves.size == 0
      puts "Monte Carlo Error, no moves seen"
      exit
    end
    # track the successfulness of each move in a hash
    move_hash = Hash.new
    possible_moves.each do |move|
      move_hash[move] = { "plays" => 0, "wins" => 0, "losses" => 0, "ties" => 0 }
    end
    current_player = @symbol
    (1..4000).each do |x|
      # test it out with monte carlo
      new_board = current_board.dup
      value_of_move = recursive_monte_carlo(new_board, current_player)
      move = value_of_move["move"]
      move_hash[move]["plays"] += 1
      if value_of_move["win"] && value_of_move["player"] == current_player
        move_hash[move]["wins"] += 1
      elsif value_of_move["win"] && value_of_move["player"] != current_player
        move_hash[move]["losses"] += 1
      end
      if value_of_move["tie"]
        move_hash[move]["ties"] += 1
      end
    end
    return get_best_monte_carlo_result(move_hash)
  end

  def recursive_monte_carlo(current_board, active_player)
    # check if this is a win or tie and return the move back if it is
    other_player = change_active_player(active_player)
    if current_board.is_there_a_win?(other_player)
      #puts "Win seen. Last Move: #{current_board.last_move_array[-1]["width"]}"
      #puts current_board
      return {"move" => current_board.last_move_array[-1]["width"],
        "player" => current_board.last_move_array[-1]["player"],
        "win" => true,
        "tie" => false}
    elsif current_board.is_there_a_tie?
      return {"move" => current_board.last_move_array[-1]["width"],
        "player" => current_board.last_move_array[-1]["player"],
        "win" => false,
        "tie" => true}
    end
    # if it's not a win, make a random move
    move = get_random_move(current_board)
    # make sure it's valid
    result = current_board.validate_and_move(move, active_player)
    if result > 6 || result < 0
      puts "Error in making a proper Monte Carlo move, exiting."
      exit(0)
    else
      # if it's valid, change players after the move is made
      active_player = change_active_player(active_player)
    end
    # go one level deeper in recursion
    recursive_result = recursive_monte_carlo(current_board, active_player)
    recursive_result["move"] = move
    return recursive_result
  end

  def get_best_monte_carlo_result(move_hash)
    highest_percentage = -100.0
    best_move = -1
    move_hash.each do |key, subhash|
      if subhash["plays"] != 0.0
        move_hash[key]["win_p"] = subhash["wins"] / subhash["plays"].to_f * 100.0
        #move_hash[key]["loss_p"] = subhash["losses"] / subhash["plays"].to_f * 100.0
        #move_hash[key]["diff_p"] = subhash["win_p"] - subhash["loss_p"].to_f
      else
        move_hash[key]["win_p"] = 0.0
      end
      calculate_based_on_win_percentage = true
      if calculate_based_on_win_percentage
        if move_hash[key]["win_p"] >= highest_percentage
          highest_percentage = move_hash[key]["win_p"]
          best_move = key
        end
      else
        if move_hash[key]["diff_p"] >= highest_percentage
          highest_percentage = move_hash[key]["diff_p"]
          best_move = key
        end
      end
    end
    #puts "Move hash: #{move_hash}"
    move_hash.each do |entry|
      puts entry
    end
    if best_move == -1
      puts "Error finding best move, exiting."
      exit
    end
    result = best_move
    return result
  end

  def change_active_player(current_player)
    if current_player == '1'
      return '2'
    else
      return '1'
    end
  end

end
