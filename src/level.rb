class Level < GameState
  traits :viewport, :timer
  attr_reader :player, :game_object_map
  
  def initialize(options = {})
    super
    
    @secret_letters = [:c,:h,:u,:n,:k,:y,:b,:a,:c,:o,:n]
    self.input = { :escape => :exit, [:c,:h,:u,:n,:k,:y,:b,:a,:o] => :chunky_bacon }
    #self.input[:e] = :edit
    self.viewport.game_area = [0, 0, 11000, 250]
    
    @file = File.join(ROOT, "level1.yml")
    load_game_objects(:file => @file)
    
    @player = Player.create(:x => 40, :y => 200)
    @grid = [16, 16]
    self.viewport.lag = 0.95
  end
  
  def setup
    @game_object_map = GameObjectMap.new(:game_objects => Block.all, :grid => @grid)
  end
  
  def edit
    push_game_state GameStates::Edit.new(:grid => @grid, :except => [Player], :file => @file)
  end
  
  def draw
    fill(Color::WHITE)
    super
  end
  
  def update
    super
    self.viewport.x = @player.x - $window.width/2   
    start_camping           if @player.x == 1716
    push_game_state(Outro)  if @player.x == 10948
    
    @player.each_collision(Camping) do |player, camping|
      player.hit_by(camping)
      camping.hit_by(player)      
      remove_rails  if player.camping_count == 3
    end
    
    @player.each_collision(Redhanded) do |player, redhanded|
      Block.all.select { |b| b.alpha == redhanded.alpha}.each do |b| 
        @game_object_map.clear_game_object(b)
        b.destroy
      end
    end
        
    $window.caption = "Whygone? A digital ode to _why on whyday 2010. http://ippa.se/gaming. [#{@player.x}/#{@player.y}]"
  end
  
  def chunky_bacon    
    if holding?(@secret_letters.first)
      if block = Block.all.find { |b| b.alpha == 190 }
        block.destroy
        Sound["chunky.wav"].play(0.4)
        @game_object_map.clear_game_object(block)
      end
      @secret_letters.delete_at(0)
    end
  end

  def remove_rails
    Block.all.select { |b| b.alpha == 250}.each do |b| 
      @game_object_map.clear_game_object(b)
      b.destroy
    end
  end
      
  def start_camping
    every(2000, :name => :campign) do
      case rand(3)
        when 0 then Camping1.create(:x => 1700-rand(300), :y => 0)
        when 1 then Camping2.create(:x => 1700-rand(300), :y => 0)
        when 2 then Camping3.create(:x => 1700-rand(300), :y => 0)
      end
    end
  end
end

class Level1 < Level; end


class Outro < GameState
  trait :timer
  
  def setup
    
    Song["Chap2-ThisBookIsMadeofRabbitsAndLemonade.ogg"].play
    
    ## Since GOSU only supporst 1024 x 1024 pixels we need to chop this up
    @outro1 = GameObject.create(:image => Image["outro1.png"], :x => $window.width/2, :y => 0, :rotation_center => :top_center)
    @outro2 = GameObject.create(:image => Image["outro2.png"], :x => $window.width/2, :y => @outro1.height, :rotation_center => :top_center)
    @outro3 = GameObject.create(:image => Image["outro3.png"],  :x => $window.width/2, :y => @outro1.height + @outro2.height, :rotation_center => :top_center)
    
    @scroll = 0
    @alpha = 0
    after(2500) { @scroll = -0.3 }
    after(129000) { @alpha = -1 }
  end
    
  def draw
    fill(Color::WHITE)
    super
  end
  
  def update
    super 
    [@outro1, @outro2, @outro3].each { |outro| outro.y += @scroll; outro.alpha += @alpha }
    $window.caption = "\"hexediting _why back to reality\". Made by ippa [ http://ippa.se/gaming + http://rubylicio.us/ ]."
    
  end
  
end