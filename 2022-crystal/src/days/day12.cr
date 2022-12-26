module Day12
  extend self

  alias Node = {pos: Pos, dist: Int32, height: Char}
  alias Pos = {x: Int32, y: Int32}
  alias Map = Array(Array(Char))

  def find_distance(to_explore : Deque(Node), map : Map, end_pos : Pos, explored : Set(Pos)) : Int32
    while cur = to_explore.shift
      _x, _y = cur[:pos][:x], cur[:pos][:y]
      [{_x, _y - 1}, {_x, _y + 1}, {_x - 1, _y}, {_x + 1, _y}].each { |x, y|
        next if x < 0 || x >= map.size || y < 0 || y >= map.first.size

        if !{x: x, y: y}.in?(explored)
          new_height = map[x][y] == 'E' ? 'z' : map[x][y]
          if new_height <= cur[:height] + 1
            if map[x][y] == 'E'
              return cur[:dist] + 1
            end

            to_explore.push({pos: {x: x, y: y}, dist: cur[:dist] + 1, height: new_height})
            explored.add({x: x, y: y})
          end
        end
      }
    end
    return -1
  end

  def run(input_file : String)
    map = File.read(input_file).lines.map(&.chars)

    end_pos = {x: 0, y: 0}
    to_explore_p1 = Deque(Node).new
    to_explore_p2 = Deque(Node).new

    (0...map.size).each { |x|
      (0...map.first.size).each { |y|
        case map[x][y]
        when 'E' then end_pos = {x: x, y: y}
        when 'a' then to_explore_p2.push({pos: {x: x, y: y}, dist: 0, height: 'a'})
        when 'S'
          to_explore_p1.push({pos: {x: x, y: y}, dist: 0, height: 'a'})
          to_explore_p2.push({pos: {x: x, y: y}, dist: 0, height: 'a'})
        end
      }
    }

    explored_p1 = Set(Pos).new(to_explore_p1.map(&.[:pos]))
    explored_p2 = Set(Pos).new(to_explore_p2.map(&.[:pos]))

    p1 = find_distance(to_explore_p1, map, end_pos, explored_p1)
    p2 = find_distance(to_explore_p2, map, end_pos, explored_p2)
    return p1, p2
  end
end
