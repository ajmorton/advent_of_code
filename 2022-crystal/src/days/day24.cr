module Day24
  extend self

  alias Pos = {Int32, Int32}
  alias Blizzard = {Pos, Char}
  alias Map = {blizzards: Set(Blizzard), width: Int32, height: Int32}

  def bliz_at(blizzard : Blizzard, time : Int32, map : Map) : Pos
    pos, dir = blizzard
    case dir
    when '^' then {(pos[0] - time - 1) % (map[:height] - 1) + 1, pos[1]}
    when 'v' then {(pos[0] + time - 1) % (map[:height] - 1) + 1, pos[1]}
    when '<' then {pos[0], (pos[1] - time - 1) % (map[:width] - 1) + 1}
    when '>' then {pos[0], (pos[1] + time - 1) % (map[:width] - 1) + 1}
    else          raise "invalid direction #{dir}"
    end
  end

  def time_to_travel(start_pos : Pos, end_pos : Pos, start_time : Int32, map : Map)
    positions = Set{start_pos}
    time = start_time

    until end_pos.in?(positions)
      on_map_moves = Set(Pos).new
      positions.each { |pos|
        pos_moves = [{pos[0] - 1, pos[1]}, {pos[0] + 1, pos[1]}, {pos[0], pos[1] - 1}, {pos[0], pos[1] + 1}, pos]
        pos_moves.each { |pos|
          on_map = ((0 < pos[0] < map[:height]) && (0 < pos[1] < map[:width])) || pos == start_pos || pos == end_pos
          if on_map
            on_map_moves.add(pos)
          end
        }
      }

      blizzards_at_time = map[:blizzards].map { |b| bliz_at(b, time + 1, map) }
      valid_moves = on_map_moves - blizzards_at_time
      positions = valid_moves
      time += 1
    end

    return time - start_time
  end

  def run(input_file : String)
    map_str = File.read(input_file).lines

    start_pos = {0, map_str.first.index('.').not_nil!}
    end_pos = {map_str.size - 1, map_str.last.index('.').not_nil!}
    map = {blizzards: Set(Blizzard).new, width: map_str.first.size - 1, height: map_str.size - 1}

    map_str.each_with_index { |line, y|
      line.chars.each_with_index { |cell, x|
        if cell.in?("<>^v")
          map[:blizzards].add({ {y, x}, cell })
        end
      }
    }

    p1 = time_to_travel(start_pos, end_pos, 0, map)
    p2 = p1
    p2 += time_to_travel(end_pos, start_pos, p2, map)
    p2 += time_to_travel(start_pos, end_pos, p2, map)

    return p1, p2
  end
end
