class Game
    CYCLES = 100
    STEP_SPEED=0.1

    attr_reader :world, :stats

    def initialize(world, stats)
        @world = world
        @stats = stats
        @generation = 0
    end
    
    def populate(width, height, rand_range)
        # For each visible cell, randomly assign life
        # starting with a 50% chance
        alive_value = rand_range.min
        width.times do |x|
            height.times do |y|
                if rand(rand_range) == alive_value
                    @world.spawn x, y
                end
            end
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