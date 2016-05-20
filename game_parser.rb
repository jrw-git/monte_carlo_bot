#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# encoding: UTF-8

# bot for theaigames.com
# connect 4
# written by John White 2016

require_relative "lib/connect_four_gameboard"
require_relative "lib/human_player"
require_relative "lib/monte_carlo_player"

STDOUT.sync = true

class BotParser

  public

  def initialize
    # set up engine
    @settings = Hash.new
  end

  def run
    # look for commands from the server
    while !$stdin.closed?
      next_line = $stdin.readline
      # skip to next loop iteration unless we get a line
      next unless next_line
      # clear some formatting
      result = process_line_of_commands(next_line)
      if result == false
        $stderr.puts "Error cascaded up to game_parser.run, exiting"
        exit(0)
      end
    end
  end

  def process_line_of_commands(command_line)
    instruction_array = command_line.strip.split
    instruction = instruction_array[0]
    case instruction
    when "settings"
      result = handle_line_of_settings(instruction_array)
    when "update"
      result = handle_line_of_update(instruction_array)
    when "action"
      result = handle_line_of_action(instruction_array)
    else
      return handle_error_in_parsing(instruction_array)
    end
    return result
  end

  private

  def handle_error_in_parsing(command_array)
    $stderr.puts "ERROR: Unrecognized input of type '#{command_array[0]}' detected: #{command_array}"
    return false
  end

  def handle_line_of_settings(instruction_array)
    # settings your_botid 1
    # all possible inputs + example numbers (most are ignored):
    # timebank, time_per_move, player_names, your_bot, your_botid, field_columns, field_rows
    # 10000        500       player1,player2   player1   1        7    6
    case instruction_array[1]
    when "your_botid"
      begin
        @our_botid = Integer(instruction_array[2])
      rescue
        return handle_error_in_parsing(instruction_array)
      end
      @our_player = MonteCarloPlayer.new(@our_botid)
      $stderr.puts "Bot setup finished, name: #{@bot_name}"
      $stderr.puts @our_bot
    when "timebank"
    when "time_per_move"
    when "player_names"
    when "your_bot"
    when "field_columns"
    when "field_rows"
    else
      return handle_error_in_parsing(instruction_array)
    end
    return true
  end

  def handle_line_of_update(instruction_array)
    # don't forget the "game" in the instruction line, need to skip it
    # update game round 1
    # update game field 0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0
    case instruction_array[2]
    when "round"
      @turn = instruction_array[3]
    when "field"
      @current_gameboard = Gameboard.new(@turn, @turn)
    else
      return handle_error_in_parsing(instruction_array)
    end
    return true
  end

  def handle_line_of_action(instruction_array)
    # action move 10000   (10000 is timeleft)
    case instruction_array[0]
    when "action"
      if instruction_array[1] == "move"
        begin
          @time_left = Integer(instruction_array[2])
        rescue
          return handle_error_in_parsing(instruction_array)
        end
        @our_move = @our_player.get_move(@current_gameboard)
        if @our_move <= 6 && @our_move >= 0
          $stdout.puts "place_disc #{@our_move}"
          return true
        else
          return handle_error_in_parsing("Bad Move Gotten From Player (#{@our_move})")
        end
      else
        return handle_error_in_parsing(instruction_array)
      end
    else
      return handle_error_in_parsing(instruction_array)
    end
  end

end

if __FILE__ == $0
  new_bot_parser = BotParser.new
  new_bot_parser.run
end
