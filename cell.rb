class Cell
    attr_accessor :x, :y, :pos
    def initialize(x, y)
      @x, @y = x, y
      @pos = [@x, @y]
    end
  end