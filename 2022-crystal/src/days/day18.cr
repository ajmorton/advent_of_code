module Day18
  extend self

  enum Cell
    Lava
    Air
    Steam
  end

  alias Pos = {Int32, Int32, Int32}

  def neighbours(pos : Pos) : Pos[6]
    x, y, z = pos
    return StaticArray[
      {x - 1, y, z}, {x, y - 1, z}, {x, y, z - 1},
      {x + 1, y, z}, {x, y + 1, z}, {x, y, z + 1},
    ]
  end

  def make_grid(drops : Array(Pos)) : Hash(Pos, Cell)
    grid = Hash(Pos, Cell).new(default_value: Cell::Air)
    # Set Lava cells
    drops.each { |d| grid[d] = Cell::Lava }

    # Border with Steam, set remaining cells to Air
    min_x, max_x = drops.map(&.[0]).min - 1, drops.map(&.[0]).max + 1
    min_y, max_y = drops.map(&.[1]).min - 1, drops.map(&.[1]).max + 1
    min_z, max_z = drops.map(&.[2]).min - 1, drops.map(&.[2]).max + 1

    (min_x..max_x).each { |x|
      (min_y..max_y).each { |y|
        (min_z..max_z).each { |z|
          if x.in?([min_x, max_x]) || y.in?([min_y, max_y]) || z.in?([min_z, max_z])
            grid[{x, y, z}] = Cell::Steam
          elsif grid[{x, y, z}]? != Cell::Lava
            grid[{x, y, z}] = Cell::Air
          end
        }
      }
    }
    return grid
  end

  def run(input_file : String)
    drops = File.read(input_file).lines.map { |line| Pos.from(line.split(",").map(&.to_i)) }
    grid = make_grid(drops)

    to_expand = Deque{ {-1, 0, 0} }

    while next_pos = to_expand.shift?
      neighbours(next_pos).each { |neighbour|
        if grid[neighbour]? == Cell::Air
          grid[neighbour] = Cell::Steam
          to_expand.push(neighbour)
        end
      }
    end

    p1 = drops.map { |drop| neighbours(drop).count { |n| grid[n] != Cell::Lava } }.sum
    p2 = drops.map { |drop| neighbours(drop).count { |n| grid[n] == Cell::Steam } }.sum
    return p1, p2
  end
end
