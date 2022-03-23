require 'gosu'

module Renderer
    class Window
        DEFAULT_CELL_SIZE=10

        class GolWindow < Gosu::Window
            def initialize(width, height)
                # colors
                @background_color = Gosu::Color.new 0xffdedede
                @cell_color = Gosu::Color.new 0xff000000

                super(width, height)
            end

            def game=(game)
                @game = game
            end

            def button_down(id)
                if id == Gosu::KB_ESCAPE
                    close
                else
                    super
                end
            end

            def update
                @game.step!
            end

            def draw
                draw_background
                @game.world.each_value do |cell|
                    draw_rect(
                        cell.x * DEFAULT_CELL_SIZE, cell.y * DEFAULT_CELL_SIZE,
                        DEFAULT_CELL_SIZE, DEFAULT_CELL_SIZE,
                        @cell_color,
                        1 # z = 1, in front of the bg
                    )
                end
            end

            def draw_background
                draw_rect(
                    0, 0,
                    width, height,
                    @background_color
                )
            end
        end

        attr_reader :options

        def initialize(game, options={})
            @game = game
            @options = options

            @x_bounds = @options[:x_bounds]
            @y_bounds = @options[:y_bounds]
            @caption = @options[:caption]
            @cell_size = (@options[:cell_size] || DEFAULT_CELL_SIZE).to_i

            width, height = (@x_bounds * @cell_size), (@y_bounds * @cell_size)
            
            @window = GolWindow.new width, height
            @window.game = game
            @window.caption = @caption || "Game of Life"
        end

        def show
            @window.show
        end
    end
end