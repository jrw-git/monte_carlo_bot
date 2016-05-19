#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# bot for theaigames.com
# connect 4
# written by John White 2016

require_relative "connect_four_gameboard"
require_relative "player"
require_relative "monte_carlo_player"

STDOUT.sync = true

class BotParser

  def initialize
    # set up engine
    @settings = Hash.new
  end

  def run
    # look for commands from the server
    while !$stdin.closed?
      next_line = $stdin.readline
      # skip to next iteration unless we get a line
      next unless next_line
      # clear some formatting
      instruction_array = next_line.strip.split
      instruction = instruction_array[0]
      case instruction
      when "settings"
        # timebank, time_per_move, player_names, your_bot, your_botid, field_columns, field_rows
        # 10000        500       player1,player2   player1   1        7    6
        @settings[instruction_array[1]] = instruction_array[2]
        if instruction_array[1] == "your_botid"
          @our_player = MonteCarloPlayer.new(instruction_array[2])
          $stderr.puts "Bot setup finished, name: #{@bot_name}"
          $stderr.puts @our_bot
        end
      when "update" # don't forget the "game" in the instruction line
        # update game round 1
        # update game field 0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0
        case instruction_array[2]
        when "round"
          @turn = instruction_array[3]
        when "field"
          @current_gameboard = Gameboard.new(@turn, instruction_array[3])
        else
          $stderr.puts "ERROR: Unknown update detected: #{instruction_array}"
        end
      when "action"
        # action move 10000   (10000 is timeleft)
        @time_left = instruction_array[2].to_i
        @our_move = @our_player.get_move(@current_board)
        $stdout.puts "place_disc #{@our_move}"
      else
        $stderr.puts "ERROR: Unknown instruction detected: #{instruction_array}"
      end
    end
  end
end

if __FILE__ == $0
  new_bot_parser = BotParser.new
  new_bot_parser.run
end
