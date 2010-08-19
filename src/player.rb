class Player < Chingu::GameObject
  trait :bounding_box, :scale => 0.8, :debug => false
  traits :timer, :collision_detection , :timer, :velocity
  
  attr_reader :camping_count
    
  def setup
    self.input = {  [:holding_left, :holding_a] => :holding_left, 
                    [:holding_right, :holding_d] => :holding_right,
                    [:down, :s] => :down,
                    [:up, :w] => :jump,
                  }
    
    #@image = Image["rabbit.png"]
    @animation = Animation.new(:file => "rabbit.png", :size => [56,64])
    @image = @animation.first
    
    @jumps = 0
    @speed = 4
    @score = 0
    @camping_count = 0
    
    self.zorder = 1000
    self.acceleration_y = 0.5
    self.max_velocity = 20
    self.rotation_center = :bottom_center
    
    self.factor = 0.4
  end
  
  def level_up
    new_factor = self.factor + 3
    between(1,500) { self.factor += 0.1 }.then { self.factor = new_factor }
  end
  
  def jumping
    @jumps > 0
  end
  
  def hit_by(object)
    if    object.class == Camping1 && @camping_count == 0
      @camping_count = 1
    elsif object.class == Camping2 && @camping_count == 1
      @camping_count = 2
    elsif object.class == Camping3 && @camping_count == 2
      @camping_count = 3
    else
      @camping_count = 0
    end
    
    #p "Got #{object.class}, @camping_count = #{@camping_count}"
  end
  
  def die
    self.collidable = false
    @color = Color::RED
    @died_at = [self.x, self.y]
    between(1,600) { self.scale += 0.4; self.alpha -= 5; }.then { resurrect }
    Sound["hurt.wav"].play(0.3)
    self.velocity_y = -13
  end
  
  def down
    self.velocity_y = 4
  end
    
  def resurrect
    self.x, self.y = @died_at
    self.velocity_x = 0
    self.velocity_y = 0    
    self.alpha = 255
    self.factor = 3
    self.collidable = true
    @color = Color::WHITE
    game_state.restore_player_position
  end

  def holding_left
    move(-@speed, 0)
  end

  def holding_right
    move(@speed, 0)
  end

  def jump
    return if @jumps == 1  
    @jumps += 1
    self.velocity_y = -11
  end
  
  def land
    @jumps = 0
  end
  
  def move(x,y)
    self.factor_x = self.factor_x.abs   if x > 0
    self.factor_x = -self.factor_x.abs  if x < 0
    
    self.x += x
    if game_state.game_object_map.from_game_object(self)
      self.x = previous_x   
      self.velocity_x = 0
    end
    @image = @animation.next  if @animation
    
    self.y += y
  end
    
  def update    
    if block = game_state.game_object_map.from_game_object(self)
      
      if self.velocity_y < 0
        self.y = block.bb.bottom + self.height
      else
        self.y = block.bb.top-1
        land
      end
      self.velocity_y = 0
      self.velocity_x = 0
    end
  end
end
