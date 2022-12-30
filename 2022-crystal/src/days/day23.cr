module Day23
  extend self

  alias Pos = {Int32, Int32}
  alias Grid = Array(Array(Bool))

  def update(grid : Grid, cur_round : Int32) : {Grid, Int32}
    num_moves = 0
    new_grid = Grid.new
    (grid.size).times { new_grid.push(Array(Bool).new(grid.first.size, false)) }

    (1...grid.size - 1).each { |y|
      (1...grid.first.size - 1).each { |x|
        next if !grid[y][x]
        new_grid[y][x] = true

        elves_above = (grid[y - 1][x - 1] || grid[y - 1][x] || grid[y - 1][x + 1])
        elves_below = (grid[y + 1][x - 1] || grid[y + 1][x] || grid[y + 1][x + 1])
        elves__left = (grid[y - 1][x - 1] || grid[y][x - 1] || grid[y + 1][x - 1])
        elves_right = (grid[y - 1][x + 1] || grid[y][x + 1] || grid[y + 1][x + 1])
        next if !(elves_above || elves_below || elves__left || elves_right)

        move_to = (0..3).each { |n|
          case (cur_round + n) % 4
          when 0 then break {y - 1, x} if !elves_above
          when 1 then break {y + 1, x} if !elves_below
          when 2 then break {y, x - 1} if !elves__left
          when 3 then break {y, x + 1} if !elves_right
          end
        }
        next if move_to.nil?

        if new_grid[move_to[0]][move_to[1]]
          # Another elf already moved here. Undo its move then do nothing
          num_moves -= 1
          new_grid[move_to[0]][move_to[1]] = false
          new_grid[move_to[0] + (move_to[0] <=> y)][move_to[1] + (move_to[1] <=> x)] = true
        else
          num_moves += 1
          new_grid[y][x] = false
          new_grid[move_to[0]][move_to[1]] = true
        end
      }
    }

    return new_grid, num_moves
  end

  def score(grid : Grid) : Int32
    elves = grid.map_with_index { |row, y|
      row.map_with_index { |cell, x| {y, x} if cell }
    }.flatten.compact

    min_y, max_y = elves.map(&.[0]).minmax
    min_x, max_x = elves.map(&.[1]).minmax

    return (max_y - min_y + 1) * (max_x - min_x + 1) - elves.size
  end

  def run(input_file : String)
    input = File.read(input_file).lines
    size_x = input.first.size
    size_y = input.size

    # Since the array is statically sized leave a buffer on all sides.
    # With * 3 this should be enough even if the input is all '#'
    grid = Grid.new
    (size_y * 3).times { grid.push(Array(Bool).new(size_x * 3, false)) }

    input.each_with_index { |line, y|
      line.chars.each_with_index { |cell, x|
        grid[y + size_y][x + size_x] = true if cell == '#'
      }
    }

    10.times { |n| grid, _ = update(grid, n) }
    p1 = score(grid)

    p2 = 10
    num_moves = -1
    while num_moves != 0
      grid, num_moves = update(grid, p2)
      p2 += 1
    end

    return p1, p2
  end
end
