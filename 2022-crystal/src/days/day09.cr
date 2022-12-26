module Day09
  extend self

  def run(input_file : String)
    moves = File.read(input_file).lines.map(&.split).map { |r| {r[0], r[1].to_i} }

    knots = [{x: 0, y: 0}] * 10
    visited = [Set({x: Int32, y: Int32}).new, Set({x: Int32, y: Int32}).new]

    moves.each { |dir, dist|
      dist.times {
        case dir
        when "U" then knots[0] = {x: knots[0][:x], y: knots[0][:y] + 1}
        when "D" then knots[0] = {x: knots[0][:x], y: knots[0][:y] - 1}
        when "L" then knots[0] = {x: knots[0][:x] - 1, y: knots[0][:y]}
        when "R" then knots[0] = {x: knots[0][:x] + 1, y: knots[0][:y]}
        else          raise "Unrecognised direction: '#{dir}'"
        end

        (1..9).each { |n|
          prev, cur = knots[n - 1], knots[n]
          if (prev[:x] - cur[:x]).abs > 1 || (prev[:y] - cur[:y]).abs > 1
            knots[n] = {x: cur[:x] + (prev[:x] <=> cur[:x]),
                        y: cur[:y] + (prev[:y] <=> cur[:y])}
          else
            # If the knot hasn't moved none of its followers will either.
            break
          end
        }

        visited[0].add(knots[1])
        visited[1].add(knots[9])
      }
    }

    return visited[0].size, visited[1].size
  end
end
