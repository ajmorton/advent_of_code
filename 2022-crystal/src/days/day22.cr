module Day22
  extend self

  RIGHT      = {y: 0, x: 1}
  DOWN       = {y: 1, x: 0}
  LEFT       = {y: 0, x: -1}
  UP         = {y: -1, x: 0}
  DIRECTIONS = [RIGHT, DOWN, LEFT, UP]

  alias Pos = {Int32, Int32}
  alias Dir = {y: Int32, x: Int32}

  def cube_wrap(new_pos : {Int32, Int32}, cur_dir : {y: Int32, x: Int32}) : { {Int32, Int32}, {y: Int32, x: Int32} }
    new_y, new_x = new_pos
    case {new_y // 50, new_x // 50, cur_dir}
    when {-1, 1, UP}   then { {new_x + 100, 0}, RIGHT }  # A UP    -> F RIGHT
    when {0, 0, LEFT}  then { {149 - new_y, 0}, RIGHT }  # A LEFT  -> E RIGHT
    when {-1, 2, UP}   then { {199, new_x - 100}, UP }   # B UP    -> F UP
    when {1, 2, DOWN}  then { {new_x - 50, 99}, LEFT }   # B DOWN  -> C LEFT
    when {0, 3, RIGHT} then { {149 - new_y, 99}, LEFT }  # B RIGHT -> D LEFT
    when {1, 0, LEFT}  then { {100, new_y - 50}, DOWN }  # C LEFT  -> E DOWN
    when {1, 2, RIGHT} then { {49, 50 + new_y}, UP }     # C RIGHT -> B UP
    when {3, 1, DOWN}  then { {100 + new_x, 49}, LEFT }  # D DOWN  -> F LEFT
    when {2, 2, RIGHT} then { {149 - new_y, 149}, LEFT } # D RIGHT -> B LEFT
    when {1, 0, UP}    then { {50 + new_x, 50}, RIGHT }  # E UP    -> C RIGHT
    when {2, -1, LEFT} then { {149 - new_y, 50}, RIGHT } # E LEFT  -> A RIGHT
    when {4, 0, DOWN}  then { {0, 100 + new_x}, DOWN }   # F DOWN  -> B DOWN
    when {3, -1, LEFT} then { {0, new_y - 100}, DOWN }   # F LEFT  -> A DOWN
    when {3, 1, RIGHT} then { {149, new_y - 100}, UP }   # F RIGHT -> D UP
    else                    raise "Invalid position #{new_pos}"
    end
  end

  def modulo_wrap(new_pos : Pos, cur_dir : Dir, map : Hash(Pos, Char), max_x : Int32, max_y : Int32) : {Pos, Dir}
    case cur_dir
    when RIGHT then new_pos = {new_pos[0], 0}
    when LEFT  then new_pos = {new_pos[0], max_x}
    when UP    then new_pos = {max_y, new_pos[1]}
    when DOWN  then new_pos = {0, new_pos[1]}
    else            return new_pos, cur_dir
    end

    until map[new_pos]?
      new_pos = {(new_pos[0] + cur_dir[:y]), new_pos[1] + cur_dir[:x]}
    end
    return new_pos, cur_dir
  end

  def walk(map : Hash(Pos, Char), path : String, p1 : Bool) : Int32
    max_x = map.keys.max_by { |pos| pos[1] }[1]
    max_y = map.keys.max_by { |pos| pos[0] }[0]

    # Top left, pointing right
    cur_pos = map.keys.select { |p| p[0] == 0 && map[p] == '.' }.min_by { |pos| pos[1] }
    cur_dir = RIGHT

    path.split(/(L|R)/).each { |instr|
      if forward = instr.to_i?
        forward.times do
          next_pos = {cur_pos[0] + cur_dir[:y], cur_pos[1] + cur_dir[:x]}
          if !map[next_pos]?
            next_pos, next_dir = p1 ? modulo_wrap(next_pos, cur_dir, map, max_x, max_y) : cube_wrap(next_pos, cur_dir)
          end

          break if map[next_pos]? == '#'
          cur_dir = next_dir ? next_dir : cur_dir
          cur_pos = next_pos
        end
      else # Turn
        dir = instr == "L" ? -1 : 1
        cur_dir = DIRECTIONS[(DIRECTIONS.index!(cur_dir) + dir) % DIRECTIONS.size]
      end
    }

    dir_score = DIRECTIONS.index!(cur_dir)
    return (1000 * (cur_pos[0] + 1)) + (4 * (cur_pos[1] + 1)) + dir_score
  end

  def run(input_file : String)
    map_str, path = File.read(input_file).split("\n\n")

    map = Hash({Int32, Int32}, Char).new
    map_str.lines.each_with_index { |line, y|
      line.chars.each_with_index { |cell, x|
        map[{y, x}] = cell if cell.in?(['.', '#'])
      }
    }

    return walk(map, path, true), walk(map, path, false)
  end
end
