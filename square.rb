class Square
  attr_reader :width, :height, :x, :y
  attr_accessor :alive
  def initialize(x, y, width, height)
    @x = x * width
    @y = y * height
    @width = width
    @height = height
    @alive = false
  end

  def alive?
    @alive
  end

  def draw
    Gosu.draw_rect(x, y, width, height, color)
  end

  def toggle
    @alive = !@alive
  end

  private

  def color
    alive? ? Gosu::Color::WHITE : Gosu::Color::BLACK
  end
end
