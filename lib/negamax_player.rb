# encoding: UTF-8

require_relative "player"

class NegamaxPlayer < Player

  attr_reader :symbol

  def initialize(player_symbol)
    @symbol = player_symbol
  end

  def get_move(current_board)
    # get list of all possible moves
    best_move = negamax(current_board, @symbol, 6)
    puts "Best move found: #{best_move}"
    return best_move
  end

  private

  def negamax(board, active_piece, depth, alpha, beta, print_result = false)
    @recursion_counter += 1
    start_time = Time.now
    hash = board.hash
    previous_best_move = nil
    # win/tie check, return a value if found
    result = check_board_for_final_square_value(board, active_piece, depth)
    return result unless result == nil
    alpha = @lowest_score if !@enable_alpha_beta
    list_of_moves = board.get_available_moves
    # move sorting
    sort_moves(list_of_moves, depth, previous_best_move) if @enable_move_sorting
    # iterate over possible moves and get their values (down to depth limit)
    list_of_moves.each do |move|
      # we are making/undoing moves rather than duping the board, better performance
      trial_move_board = board
      trial_move_board.make_move(move, active_piece)
      subtree_best = -negamax(trial_move_board, trial_move_board.change_players(active_piece), depth-1, -beta, -alpha)
      @io_stream.puts "M#{move}:#{subtree_best}" if print_result
      trial_move_board.undo_move
      if subtree_best.value > alpha.value
        # new local alpha (best move) was found
        @io_stream.puts "New Local Best (Alpha) Found, Val:#{alpha.value}, subtreeVal:#{subtree_best.value}" if print_result
        alpha = insert_move_into_results(subtree_best, move)
      end
      # alpha beta (and killer moves)
      if subtree_best.value >= beta.value && @enable_alpha_beta
        #@io_stream.puts "Beta break, beta val #{beta.value}, subtreeVal:#{subtree_best.value}" if depth > 4
        if @enable_killer_moves
          # storing two killer moves, but only if they are different than the move currently considered
          if subtree_best.move != @killer_moves[1][depth] && subtree_best.move != @killer_moves[0][depth]
            @killer_moves[0][depth] = @killer_moves[1][depth]
            @killer_moves[1][depth] = subtree_best
          end
        end
        # Beta cutoff, break out of this level with our alpha
        # returning best value would be "fail soft"
        break if @enable_fail_soft
        # returning beta is "fail hard"
        alpha = beta if !@enable_fail_soft
        break if !@enable_fail_soft
      end
    end
    return cut_node_value_by_half(alpha)
  end


end
