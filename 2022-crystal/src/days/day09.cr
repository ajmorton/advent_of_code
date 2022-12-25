module Day09
  extend self

  def run(input_file : String)
    moves = File.read(input_file).lines.map(&.split).map { |r| {r[0], r[1].to_i} }

    knots = [{x: 0, y: 0}] * 10
    visited = [Hash({Int32, Int32}, Bool).new, Hash({Int32, Int32}, Bool).new]

    moves.each { |dir, dist|
      dist.times {
        case dir
        when "U" then knots[0] = {x: knots[0][:x], y: knots[0][:y] + 1}
        when "D" then knots[0] = {x: knots[0][:x], y: knots[0][:y] - 1}
        when "L" then knots[0] = {x: knots[0][:x] - 1, y: knots[0][:y]}
        when "R" then knots[0] = {x: knots[0][:x] + 1, y: knots[0][:y]}
        else
          raise ""
        end

        (1..9).each { |n|
          if (knots[n - 1][:x] - knots[n][:x]).abs > 1 || (knots[n - 1][:y] - knots[n][:y]).abs > 1
            knots[n] = {x: knots[n][:x] + (knots[n - 1][:x] <=> knots[n][:x]),
                        y: knots[n][:y] + (knots[n - 1][:y] <=> knots[n][:y])}
          end
        }

        visited[0][{knots[1][:x], knots[1][:y]}] = true
        visited[1][{knots[9][:x], knots[9][:y]}] = true
      }
    }

    return visited[0].size, visited[1].size
  end
end
