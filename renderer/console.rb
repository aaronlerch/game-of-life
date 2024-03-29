require 'curses'

module Renderer
  class Console
    DEFAULT_SPEED=0.016

    class DisplayHelper
      WHITE=255

      class << self
        def init
          Curses.noecho
          Curses.init_screen
          Curses.crmode
          Curses.curs_set 0 # invisible
          Curses.start_color
        end

        def with_color(color)
          Curses.init_pair(color, color, 0)
          Curses.attrset(Curses.color_pair(color))

          yield

          Curses.init_pair(WHITE, WHITE, 0)
          Curses.attrset(Curses.color_pair(WHITE))
        end

        def draw
          Curses.refresh
          yield
          Curses.refresh
        end

        def close
          Curses.close_screen
        end
      end
    end

    attr_reader :options, :width, :height

    def initialize(game, options={})
      @game = game
      @options = options

      @caption = @options[:caption] || "Game of Life"
      @speed = @options[:speed] || DEFAULT_SPEED
      begin
        # We need to init Curses in order to get the width/height
        DisplayHelper.init
        @width = @options[:width] || Curses.cols
        @height = @options[:height] || Curses.lines
        Curses.timeout = @speed
      ensure
        DisplayHelper.close
      end
    end

    def show
      # this should start the event loop which triggers game steps and renders the game
      begin
        DisplayHelper.init
        # Loop until ESC pressed (or CTRL+C)
        while true
          @game.step!
          draw

          # Normally we'd sleep for @speed but instead we are using Curses.timeout to wait
          # for the duration of the wait period, so that we can use the opportunity to
          # gather input and take actions
          char = Curses.getch
          break if char == 'q'
        end
      rescue Interrupt => e
      ensure
        DisplayHelper.close
      end
    end

    def draw
      Curses.clear
      DisplayHelper.draw do
        @game.world.each_value do |cell|
          # don't draw items outside our viewport
          next if cell.x < 0 || cell.x > width || cell.y < 0 || cell.y > height
          Curses.setpos(cell.y, cell.x)
          DisplayHelper.with_color(DisplayHelper::WHITE) do
              Curses.addstr '*'
          end
        end
      end
    end
  end
end