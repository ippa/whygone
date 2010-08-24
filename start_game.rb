#!/usr/bin/env ruby
require 'rubygems' rescue nil
begin
  raise LoadError if defined?(Ocra)
  require '../chingu/lib/chingu'
rescue LoadError
  require 'chingu'
end
include Gosu
include Chingu

require_rel 'src/*'
DEBUG = false
ENV['PATH'] = File.join(ROOT) + ";" + ENV['PATH'] # so ocra finds fmod.dll

class Game < Chingu::Window 
  def initialize
    super(1000,250)
  end
  
  def setup
    self.retrofy
    push_game_state(Level1)
  end  
end

Game.new.show