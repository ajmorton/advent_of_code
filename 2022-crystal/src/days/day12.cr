module Day12
  extend self

  alias Node = {pos: Pos, dist: Int32}
  alias Pos = {x: Int32, y: Int32}
  alias Map = Array(Array(Char))

  def find_distance(to_explore : Deque(Node), map : Map, end_pos : Pos, explored : Hash(Pos, Bool)) : Int32
    while to_explore.size > 0
      cur = to_explore.shift

      _x, _y = cur[:pos][:x], cur[:pos][:y]
      [{_x, _y - 1}, {_x, _y + 1}, {_x - 1, _y}, {_x + 1, _y}].each { |x, y|
        if x < 0 || x >= map.size || y < 0 || y >= map.first.size
          next
        end

        if !explored[{x: x, y: y}]
          cur_height = map[cur[:pos][:x]][cur[:pos][:y]]
          new_height = map[x][y]
          if new_height <= cur_height + 1
            if {x: x, y: y} == end_pos
              return cur[:dist] + 1
            end

            to_explore.push({pos: {x: x, y: y}, dist: cur[:dist] + 1})
            explored[{x: x, y: y}] = true
          end
        end
      }
    end
    return -1
  end

  def run(input_file : String)
    map = File.read(input_file).lines.map(&.chars)

    start_pos = {x: 0, y: 0}
    end_pos = {x: 0, y: 0}

    to_explore_p1 = Deque(Node).new
    to_explore_p2 = Deque(Node).new

    (0...map.size).each { |x|
      (0...map.first.size).each { |y|
        case map[x][y]
        when 'S'
          start_pos = {x: x, y: y}
          map[x][y] = 'a'
          to_explore_p1.push({pos: {x: x, y: y}, dist: 0})
        when 'E'
          end_pos = {x: x, y: y}
          map[x][y] = 'z'
        when 'a'
          to_explore_p2.push({pos: {x: x, y: y}, dist: 0})
        end
      }
    }

    explored = Hash(Pos, Bool).new(default_value: false)
    explored[start_pos] = true

    p1 = find_distance(to_explore_p1, map, end_pos, explored.clone)
    p2 = find_distance(to_explore_p2, map, end_pos, explored.clone)
    return p1, p2
  end
end
