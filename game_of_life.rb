require 'gosu'
require_relative 'square'

class GameOfLife < Gosu::Window
  attr_reader :width, :height, :num

  def initialize
    @width = 800
    @height = 600
    super @width, @height, fullscreen: false

    @num = 100
    @board = create_board(@width, @height)
    @state = create_state
    @running = false
    @max_counter = 100
    @counter = @max_counter
    # randomize_board
  end

  def button_down(button)
    case button
    when Gosu::KbEscape
      close
    when Gosu::KbSpace
      @running = !@running
    when Gosu::MsLeft
      handle_left_mouse_click(mouse_x, mouse_y)
    when Gosu::KbR
      randomize_board
    when Gosu::KbEqual
      @max_counter -= 50
    when Gosu::KbMinus
      @max_counter += 50
    end
  end

  def handle_left_mouse_click(mouse_x, mouse_y)
    x = (mouse_x / (width / num)).to_i
    y = (mouse_y / (height / num)).to_i

    @board[x][y].toggle
    @state[x][y] = !@state[x][y]
  end

  def randomize_board
    size = @board.length
    size.times do |x|
      size.times do |y|
        alive = (0 == rand(2))
        @board[x][y].alive = alive
        @state[x][y] = alive
      end
    end
  end

  def update
    return if !@running

    @counter -= update_interval

    if @counter > 0
      return
    else
      @counter = @max_counter
    end

    size = @board.length
    current_state = Array.new(size)
    size.times do |x|
      current_state[x] = @state[x].dup
    end

    @board.length.times do |i|
      @board.length.times do |j|
        num_alive_neighbors = num_alive_neighbors(i, j, current_state)
        if num_alive_neighbors < 2 || num_alive_neighbors > 3
          @board[i][j].alive = false
          @state[i][j] = false
        elsif num_alive_neighbors == 3
          @board[i][j].alive = true
          @state[i][j] = true
        end
      end
    end
  end

  def draw
    @board.each do |row|
      row.each do |square|
        square.draw
      end
    end
  end

  private

  def create_board(width, height)
    [].tap do |board|
      num.times do |i|
        board << Array.new
        num.times do |j|
          board[i][j] = Square.new(i, j, width / num, height / num)
        end
      end
    end
  end

  def create_state
    Array.new(num) { Array.new(num, false) }
  end

  def num_alive_neighbors(i, j, current_state)
    max = current_state.length
    count = 0

    -1.upto(1) do |x|
      -1.upto(1) do |y|
        next if x == 0 && y == 0 # Self is not a neighbor
        check_x = i + x
        check_y = j + y
        next if check_x < 0 || check_y < 0 || check_x >= max || check_y >= max

        count += 1 if current_state[check_x][check_y]
      end
    end
    count
  end
end

gol = GameOfLife.new
gol.show
