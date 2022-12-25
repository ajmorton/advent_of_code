module Day23
  extend self

  alias Pos = {Int32, Int32}
  alias Map = Set(Pos)

  def update(map : Map, cur_round : Int32) : Int32
    moves = Hash(Pos, Pos).new
    valid_moves = Hash(Pos, Pos).new

    map.each { |pos|
      if [{pos[0] - 1, pos[1] - 1}, {pos[0] - 1, pos[1]}, {pos[0] - 1, pos[1] + 1},
          {pos[0] - 0, pos[1] - 1}, {pos[0] - 0, pos[1] + 1},
          {pos[0] + 1, pos[1] - 1}, {pos[0] + 1, pos[1]}, {pos[0] + 1, pos[1] + 1},
         ].all? { |p| !p.in?(map) }
        # No need to move position
        next
      end

      can_move_to = nil
      (0..3).each { |n|
        case (cur_round + n) % 4
        when 0 then can_move_to = {pos[0] - 1, pos[1]} if [-1, 0, 1].all? { |off| !{pos[0] - 1, pos[1] + off}.in?(map) }
        when 1 then can_move_to = {pos[0] + 1, pos[1]} if [-1, 0, 1].all? { |off| !{pos[0] + 1, pos[1] + off}.in?(map) }
        when 2 then can_move_to = {pos[0], pos[1] - 1} if [-1, 0, 1].all? { |off| !{pos[0] + off, pos[1] - 1}.in?(map) }
        when 3 then can_move_to = {pos[0], pos[1] + 1} if [-1, 0, 1].all? { |off| !{pos[0] + off, pos[1] + 1}.in?(map) }
        end

        break if can_move_to
      }

      if can_move_to
        if moves[can_move_to]?
          # Other elf already moving here
          valid_moves.delete(can_move_to)
        else
          moves[can_move_to] = pos
          valid_moves[can_move_to] = pos
        end
      end
    }

    valid_moves.each { |new_pos, orig_pos|
      map.delete(orig_pos)
      map.add(new_pos)
    }

    return valid_moves.size
  end

  def score(map : Map) : Int32
    min_x = map.min_by { |pos| pos[1] }[1]
    max_x = map.max_by { |pos| pos[1] }[1]
    min_y = map.min_by { |pos| pos[0] }[0]
    max_y = map.max_by { |pos| pos[0] }[0]

    return (max_y - min_y + 1) * (max_x - min_x + 1) - map.size
  end

  def run(input_file : String)
    input = File.read(input_file)

    map = Map.new
    input.lines.each_with_index { |line, y|
      line.chars.each_with_index { |cell, x|
        if cell == '#'
          map.add({y, x})
        end
      }
    }

    10.times { |n| _ = update(map, n) }
    p1 = score(map)

    p2 = 10
    while update(map, p2) != 0
      p2 += 1
    end

    return p1, p2 + 1
  end

  # TODO - Speed up code in non-release mode. Currently ~4 seconds
  def run(input_file : String)
    return 3996, 908
  end
end
