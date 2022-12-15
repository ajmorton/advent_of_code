module Day14
  extend self

  alias Pos = {x: Int32, y: Int32}
  enum Cell
    Sand
    Stone
  end

  def pour(cells : Hash(Pos, Cell), bottom : Int32) : {Int32, Int32}
    first_void = -1

    # Track previous positions reached by sand. Each subsequent grain will also
    # reach this position so we can skip recomputation.
    prev_poses = [{x: 500, y: 0}]
    loop do # pouring
      sand = prev_poses.pop
      loop do # falling
        x, y = sand[:x], sand[:y]
        prev_poses.push({x: x, y: y})

        if first_void == -1 && y == bottom
          first_void = cells.values.count(Cell::Sand)
        end

        if !cells[{x: x, y: y + 1}]? && y + 1 != bottom + 2
          sand = {x: x, y: y + 1}
        elsif !cells[{x: x - 1, y: y + 1}]? && y + 1 != bottom + 2
          sand = {x: x - 1, y: y + 1}
        elsif !cells[{x: x + 1, y: y + 1}]? && y + 1 != bottom + 2
          sand = {x: x + 1, y: y + 1}
        else
          prev_poses.pop
          cells[sand] = Cell::Sand
          if sand[:x] == 500 && sand[:y] == 0
            return first_void, cells.values.count(Cell::Sand)
          else
            break
          end
        end
      end
    end
  end

  def run(input_file : String)
    paths = File.read(input_file).lines.map(&.split(" -> ").map(&.split(",").map(&.to_i)))

    cells = Hash(Pos, Cell).new
    bottom = 0

    paths.each { |p|
      pos = {x: p[0][0], y: p[0][1]}
      p[1..].each { |p2|
        dest = {x: p2[0], y: p2[1]}
        x_dir = dest[:x] <=> pos[:x]
        y_dir = dest[:y] <=> pos[:y]

        until pos === dest
          cells[pos] = Cell::Stone
          bottom = Math.max(bottom, pos[:y])
          pos = {x: pos[:x] + x_dir, y: pos[:y] + y_dir}
        end
        cells[pos] = Cell::Stone
      }
    }

    return pour(cells, bottom)
  end
end
