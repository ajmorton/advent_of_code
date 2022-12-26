module Day08
  extend self

  alias Grid = Array(Array(Int32))

  def vis_checks(x : Int32, y : Int32, grid : Grid, grid_flipped : Grid, width : Int32, height : Int32) : {Bool, Int32}
    tree_height = grid[y][x]
    w, h = width, height

    # Find closest taller tree in each cardinal direction
    to_w = (w - x...w).index { |xx| grid_flipped[(height - 1) - y][xx] >= tree_height }
    to_e = (x + 1...w).index { |xx| grid[y][xx] >= tree_height }
    to_n = (h - y...h).index { |yy| grid_flipped[yy][(width - 1) - x] >= tree_height }
    to_s = (y + 1...h).index { |yy| grid[yy][x] >= tree_height }

    dist_w = to_w ? to_w + 1 : x
    dist_e = to_e ? to_e + 1 : (width - 1) - x
    dist_n = to_n ? to_n + 1 : y
    dist_s = to_s ? to_s + 1 : (height - 1) - y

    vis_from_edge = to_w.nil? || to_e.nil? || to_n.nil? || to_s.nil?
    vis_score = dist_w * dist_e * dist_n * dist_s
    return vis_from_edge, vis_score
  end

  def run(input_file : String)
    grid = File.read(input_file).lines.map(&.strip.chars.map(&.to_i))
    # Reverse iterators are kinda slow. Instead store the grid flipped in both directions and use forward iterators.
    grid_flipped = grid.map(&.reverse).reverse
    width, height = grid[0].size, grid.size

    p1 = p2 = 0
    (0...height).each do |y|
      (0...width).each do |x|
        is_vis, score = vis_checks(y, x, grid, grid_flipped, width, height)
        p1 += 1 if is_vis
        p2 = Math.max(score, p2)
      end
    end

    return p1, p2
  end
end
