module Renderer
  class Console
    def initialize(game, options={})
      @game = game
      @options = options

      @x_bounds = @options[:x_bounds]
      @y_bounds = @options[:y_bounds]
      @caption = @options[:caption]
    end

    def show
      raise "not implemented yet"
    end

    def render(world, adornment=nil)
      o = "" + adornment.to_s # o is for output
      border = "=" * (@x_bounds+1)
      o << border << "\n"

      # Dynamic render window: figure out min and max y and x values in the map
      min_x = min_y = 0
      max_x = @x_bounds
      max_y = @y_bounds

      # use a dynamic window size
      if world.count > 0
        min_x = world.min_by { |i| i[0][0] }[0][0]
        max_x = world.max_by { |i| i[0][0] }[0][0]
        min_y = world.min_by { |i| i[0][1] }[0][1]
        max_y = world.max_by { |i| i[0][1] }[0][1]
      end

      (min_y...max_y).each do |y|
        (min_x...max_x).each do |x|
          cell = world.cell_at x, y
          if cell
            o << '*'
          else
            o << ' '
          end
        end
        o << "\n"
      end
      o << border

      puts o
    end
  end
end