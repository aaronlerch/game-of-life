require 'gosu'

module Renderer
    class Window
        DEFAULT_CELL_SIZE=10

        class GolWindow < Gosu::Window
            def initialize(width, height, cell_size)
                # colors
                @background_color = Gosu::Color.new 0xffdedede
                @cell_color = Gosu::Color.new 0xff000000
                @cell_size = cell_size || DEFAULT_CELL_SIZE
                @paused = false

                super(width, height)
            end

            def game=(game)
                @game = game
            end

            def button_down(id)
                case id
                when Gosu::KB_ESCAPE
                when Gosu::KB_Q
                    close
                when Gosu::KB_SPACE
                    @paused = !@paused
                else
                    super
                end
            end

            def update
                @game.step! unless @paused
            end

            def draw
                draw_background
                @game.world.each_value do |cell|
                    # don't draw items outside our viewport
                    next if cell.x < 0 || cell.x * @cell_size > width || cell.y < 0 || cell.y * @cell_size > height
                    draw_rect(
                        cell.x * @cell_size, cell.y * @cell_size,
                        @cell_size, @cell_size,
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

        attr_reader :options, :width, :height

        def initialize(game, options={})
            @game = game
            @options = options

            @caption = @options[:caption] || "Game of Life"
            @cell_size = (@options[:cell_size] || DEFAULT_CELL_SIZE).to_i
            @width = @options[:width] || (Gosu.available_width / @cell_size)
            @height = @options[:height] || (Gosu.available_height / @cell_size)

            window_width, window_height = (@width * @cell_size), (@height * @cell_size)
            
            @window = GolWindow.new window_width, window_height, @cell_size
            @window.game = game
            @window.caption = @caption
        end

        def show
            @window.show
        end
    end
end