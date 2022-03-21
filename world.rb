class World < Hash
    def spawn(x,y)
      cell = Cell.new x, y
      self[cell.pos] = cell
      cell
    end
  
    def cell_at(x,y)
      self[[x,y]]
    end

    def randomly_fill(cell_count, x_bounds, y_bounds)
      # Fill the world by placing #cell_count random spots
      cell_count.times do |i|
          x = rand(0..x_bounds)
          y = rand(0..y_bounds)
          self.spawn x, y
      end
    end
  
    def step
      # Given all cells die or stay dead by default, we initialize a new empty world
      # then we spawn cells to match the cells in the current step that should live, or come to life
      new_world = World.new
  
      # for each current live cell, survive if 2-3 neighbors
      self.each_pair do |pos,cell|
        x, y = pos
        count = count_neighbors_of x, y
        new_world.spawn(x, y) if count == 2 || count == 3
      end
      # for each empty adjacent spot in current, spawn if neighbors == 3
      self.each_pair do |pos,cell|
        x, y = pos
        empties = get_empty_neighbors_of x, y
        empties.each do |empty|
          x, y = empty
          count = count_neighbors_of x, y
          new_world.spawn(x, y) if count == 3
        end
      end
  
      new_world
    end

  private
    def neighbor_positions_for(x, y)
      [
        # up left, up, up right
        [x-1, y-1],
        [x, y-1],
        [x+1, y-1],
        # left, right
        [x-1, y],
        [x+1, y],
        # down left, down, down right
        [x-1, y+1],
        [x, y+1],
        [x+1, y+1]
      ]
    end

    def count_neighbors_of(x, y)
      count = 0
  
      positions = neighbor_positions_for(x, y)
      positions.each do |pos|
        count += 1 if self[pos]
      end
      count
    end
  
    def get_empty_neighbors_of(x, y)
      empty_neighbors = []
      positions = neighbor_positions_for(x, y)
      positions.each do |pos|
        empty_neighbors << pos unless self.has_key? pos
      end
      empty_neighbors
    end
  end