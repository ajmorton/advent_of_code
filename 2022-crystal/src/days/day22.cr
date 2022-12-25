module Day22
  extend self

  enum Cell
    Wall
    Open
  end

  RIGHT      = {y: 0, x: 1}
  DOWN       = {y: 1, x: 0}
  LEFT       = {y: 0, x: -1}
  UP         = {y: -1, x: 0}
  DIRECTIONS = [RIGHT, DOWN, LEFT, UP]

  alias Box = {y: Range(Int32, Int32), x: Range(Int32, Int32)}
  alias Pos = {Int32, Int32}
  alias Dir = {y: Int32, x: Int32}

  A = {y: (0..49), x: (50..99)}
  B = {y: (0..49), x: (100..149)}
  C = {y: (50..99), x: (50..99)}
  D = {y: (100..149), x: (50..99)}
  E = {y: (100..149), x: (0..49)}
  F = {y: (150..199), x: (0..49)}

  def l_edge(box : Box)
    { {box[:y], box[:x].min - 1}, LEFT }
  end

  def r_edge(box : Box)
    { {box[:y], box[:x].max + 1}, RIGHT }
  end

  def u_edge(box : Box)
    { {box[:y].min - 1, box[:x]}, UP }
  end

  def d_edge(box : Box)
    { {box[:y].max + 1, box[:x]}, DOWN }
  end

  def transform(pos : Pos, a : Box, a_dir : Dir, b : Box, b_dir : Dir) : {Pos, Dir}
    offset = nil
    case a_dir
    when UP    then offset = pos[1] - a[:x].min
    when DOWN  then offset = a[:x].max - pos[1]
    when LEFT  then offset = a[:y].max - pos[0]
    when RIGHT then offset = pos[0] - a[:y].min
    end
    offset = offset.not_nil!

    final_pos = nil
    case b_dir
    when UP    then final_pos = {b[:y].max, b[:x].min + offset}
    when DOWN  then final_pos = {b[:y].min, b[:x].max - offset}
    when LEFT  then final_pos = {b[:y].max - offset, b[:x].max}
    when RIGHT then final_pos = {b[:y].min + offset, b[:x].min}
    end
    final_pos = final_pos.not_nil!

    return {final_pos, b_dir}
  end

  def cube_wrap(new_pos : {Int32, Int32}, cur_dir : {y: Int32, x: Int32}) : { {Int32, Int32}, {y: Int32, x: Int32} }
    # JFC
    # As we're off the map cur_dir implies the prev pos

    new_y, new_x = new_pos
    case { {new_y, new_x}, cur_dir }
    when u_edge(A) then transform(new_pos, A, UP, F, RIGHT)   # A UP    -> F RIGHT
    when l_edge(A) then transform(new_pos, A, LEFT, E, RIGHT) # A LEFT  -> E RIGHT
    when u_edge(B) then transform(new_pos, B, UP, F, UP)      # B UP    -> F UP
    when d_edge(B) then transform(new_pos, B, DOWN, C, LEFT)  # B DOWN  -> C LEFT
    when r_edge(B) then transform(new_pos, B, RIGHT, D, LEFT) # B RIGHT -> D LEFT
    when l_edge(C) then transform(new_pos, C, LEFT, E, DOWN)  # C LEFT  -> E DOWN
    when r_edge(C) then transform(new_pos, C, RIGHT, B, UP)   # C RIGHT -> B UP
    when d_edge(D) then transform(new_pos, D, DOWN, F, LEFT)  # D DOWN  -> F LEFT
    when r_edge(D) then transform(new_pos, D, RIGHT, B, LEFT) # D RIGHT -> B LEFT
    when u_edge(E) then transform(new_pos, E, UP, C, RIGHT)   # E UP    -> C RIGHT
    when l_edge(E) then transform(new_pos, E, LEFT, A, RIGHT) # E LEFT  -> A RIGHT
    when d_edge(F) then transform(new_pos, F, DOWN, B, DOWN)  # F DOWN  -> B DOWN
    when l_edge(F) then transform(new_pos, F, LEFT, A, DOWN)  # F LEFT  -> A DOWN
    when r_edge(F) then transform(new_pos, F, RIGHT, D, UP)   # F RIGHT -> D UP
    else                raise "Invalid position #{new_pos}"
    end
  end

  def modulo_wrap(new_pos : Pos, cur_dir : Dir, map : Hash(Pos, Cell), max_x : Int32, max_y : Int32) : Pos
    case cur_dir
    when RIGHT then new_pos = {new_pos[0], 0}
    when LEFT  then new_pos = {new_pos[0], max_x}
    when UP    then new_pos = {max_y, new_pos[1]}
    when DOWN  then new_pos = {0, new_pos[1]}
    else            raise "Bad dir"
    end

    until next_cell = map[new_pos]?
      new_pos = {(new_pos[0] + cur_dir[:y]), new_pos[1] + cur_dir[:x]}
    end
    return new_pos
  end

  def walk(map : Hash(Pos, Cell), path : String, p1 : Bool) : Int32
    max_x = map.keys.max_by { |pos| pos[1] }[1]
    max_y = map.keys.max_by { |pos| pos[0] }[0]

    # Top left, pointing right
    cur_pos = map.keys.select { |p| p[0] == 0 && map[p] == Cell::Open }.min_by { |pos| pos[1] }
    cur_dir = RIGHT

    path.split(/(L|R)/).each { |instr|
      if forward = instr.to_i?
        forward.times do
          next_pos = {cur_pos[0] + cur_dir[:y], cur_pos[1] + cur_dir[:x]}
          if !map[next_pos]?
            # Wrap around
            if p1
              next_pos = modulo_wrap(next_pos, cur_dir, map, max_x, max_y)
            else
              next_pos, next_dir = cube_wrap(next_pos, cur_dir)
            end
          end

          break if map[next_pos]? == Cell::Wall
          cur_dir = next_dir ? next_dir : cur_dir
          cur_pos = next_pos
        end
      else
        # Turn
        dir = instr == "L" ? -1 : 1
        cur_dir = DIRECTIONS[(DIRECTIONS.index!(cur_dir) + dir) % DIRECTIONS.size]
      end
    }

    dir_score = DIRECTIONS.index!(cur_dir)
    return (1000 * (cur_pos[0] + 1)) + (4 * (cur_pos[1] + 1)) + dir_score
  end

  def run(input_file : String)
    map_str, path = File.read(input_file).split("\n\n")

    map = Hash({Int32, Int32}, Cell).new
    map_str.lines.each_with_index { |line, y|
      line.chars.each_with_index { |cell, x|
        case cell
        when ' ' then next # No need to consider
        when '#' then map[{y, x}] = Cell::Wall
        when '.' then map[{y, x}] = Cell::Open
        else          raise "Error"
        end
      }
    }

    return {
      walk(map, path.clone, true),
      walk(map, path.clone, false),
    }
  end
end
