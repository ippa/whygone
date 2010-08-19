class Block < GameObject
  trait :collision_detection
  trait :bounding_box, :debug => false
  
  def setup
    @image = Image["block.png"]
    self.zorder = 10
  end
  
  def hit
  end
end

class Camping < GameObject
  traits :velocity, :collision_detection
  trait :bounding_box, :scale => 0.80
  
  def setup
    @image = Image["#{self.filename}.png"]
    self.velocity_y = 1.5
    self.zorder = 1
  end
  
  def hit_by(object)
    Sound["camping.wav"].play(0.3)
    destroy
  end
    
end


class Camping1 < Camping; end;
class Camping2 < Camping; end;
class Camping3 < Camping; end;


class Redhanded < GameObject
  traits :collision_detection, :bounding_box
  
  def setup
    @image = Image["#{self.filename}.png"]
    size = [32,32]
  end
end

class ChunkyBacon < GameObject
  traits :collision_detection, :bounding_box
  
  def setup
    @image = Image["chunky_bacon.png"]
  end
end