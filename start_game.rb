#!/usr/bin/env ruby
require 'rubygems'
require File.join(File.dirname($0), "../", "chingu", "lib", "chingu")
#require 'chingu'
include Gosu
include Chingu

require_rel 'src/*'
DEBUG = false

class Game < Chingu::Window 
  def initialize
    super(1000,250)
  end
  
  def setup
    retrofy
    Sound["camping.wav"]    # lame cache line
    push_game_state(Level1)
  end    
end

Game.new.show