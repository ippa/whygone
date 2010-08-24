class Player < Chingu::GameObject
  trait :bounding_box, :scale => 0.8, :debug => false
  traits :collision_detection, :timer, :velocity
  
  attr_reader :camping_count
    
  def setup
    self.input = {  [:holding_left, :holding_a] => :holding_left, 
                    [:holding_right, :holding_d] => :holding_right,
                    [:down, :s] => :down,
                    [:up, :w] => :jump,
                  }
                  
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
  end
  
  def down
    self.velocity_y = 4
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
    @image = @animation.next  if @animation
    
    self.x += x
    self.x = previous_x if game_state.game_object_map.from_game_object(self)
    
    self.y += y
    if block = game_state.game_object_map.from_game_object(self)
      if self.velocity_y < 0
        self.y = block.bb.bottom + self.height
      else
        self.y = block.bb.top-1
        land
      end
      self.velocity_y = 0
    end
  end
end
