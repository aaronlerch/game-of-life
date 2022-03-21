class Game
    CYCLES = 100
    STEP_SPEED=0.1

    attr_reader :world, :stats

    def initialize(world, stats)
        @world = world
        @stats = stats
        @generation = 0
    end
    
    def populate(initial_fill_count, window_bounds_x, window_bounds_y)
        # Fill the world by placing N random spots
        initial_fill_count.times do |i|
            x = rand(0..window_bounds_x)
            y = rand(0..window_bounds_y)
            @world.spawn x, y
        end
    end

    def start
        begin
            #@renderer.show
            # @renderer.render(@world)
          
            # CYCLES.times do |i|
            #   new_world = @world.step
            #   delta = new_world.count - @world.count
            #   @stats.capture({
            #     step: i,
            #     previous_count: @world.count,
            #     new_count: new_world.count,
            #     delta: delta,
            #   })
          
            #   @world = new_world
            #   @renderer.render(@world)
            #   sleep STEP_SPEED
            # end
          rescue Interrupt => e
            puts "\ninterrupted, stopping\n"
          end
    end

    def step!
        @generation += 1
        new_world = @world.step
        delta = new_world.count - @world.count
        @stats.capture({
            step: @generation,
            previous_count: @world.count,
            new_count: new_world.count,
            delta: delta,
        })
    
        @world = new_world
    end
end