module Day08
  extend self

  def vis_checks(grid : Array(Array(Int32)), width : Int32, height : Int32, x : Int32, y : Int32) : {Bool, Int32}
    vis_left = vis_right = vis_up = vis_down = true
    num_left = num_right = num_up = num_down = 0

    tree_height = grid[y][x]

    # left
    (0...x).reverse_each do |xx|
      num_left += 1
      if grid[y][xx] >= tree_height
        vis_left = false
        break
      end
    end

    # right
    (x + 1...width).each do |xx|
      num_right += 1
      if grid[y][xx] >= tree_height
        vis_right = false
        break
      end
    end

    # up
    (0...y).reverse_each do |yy|
      num_up += 1
      if grid[yy][x] >= tree_height
        vis_up = false
        break
      end
    end

    # down
    (y + 1...height).each do |yy|
      num_down += 1
      if grid[yy][x] >= tree_height
        vis_down = false
        break
      end
    end

    return (vis_left || vis_right || vis_up || vis_down), (num_left * num_right * num_up * num_down)
  end

  def run(input_file : String)
    grid = File.read(input_file).lines.map(&.chars.map(&.to_i))
    p1 = p2 = 0

    width = grid[0].size
    height = grid.size

    (0...height).each do |y|
      (0...width).each do |x|
        is_vis, score = vis_checks(grid, width, height, y, x)
        p1 += is_vis ? 1 : 0
        p2 = Math.max(score, p2)
      end
    end

    return p1, p2
  end
end
