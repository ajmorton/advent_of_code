module Day17
  extend self

  def conflict(new_pos : {Int32, Int32}, rock : Array({Int32, Int32}), map : Hash({Int32, Int32}, Bool)) : Bool
    rock.each { |part|
      new_loc = {new_pos[0] + part[0], new_pos[1] + part[1]}
      case
      when map[new_loc]                      then return true
      when new_loc[0] < 0 || new_loc[0] >= 7 then return true
      when new_loc[1] < 0                    then return true
      end
    }
    return false
  end

  def run(input_file : String)
    p1 = p2 = 0

    minus = [{0, 0}, {1, 0}, {2, 0}, {3, 0}]
    plus = [{1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2}]
    corner = [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}]
    vert = [{0, 0}, {0, 1}, {0, 2}, {0, 3}]
    box = [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
    rock_order = [minus, plus, corner, vert, box]

    gas_bursts = File.read(input_file)
    map = Hash({Int32, Int32}, Bool).new(default_value: false)

    i = 0
    max_height = -1
    (1..10_000).each { |r|
      if r == 2023
        p1 = max_height + 1
      end

      rock = rock_order[r % rock_order.size]
      rock_pos = {2, max_height + 4}
      orig_pos = rock_pos

      loop do # Falling

        new_pos = if gas_bursts[i % gas_bursts.size] == '>'
                    {rock_pos[0] + 1, rock_pos[1]}
                  else
                    {rock_pos[0] - 1, rock_pos[1]}
                  end

        unless conflict(new_pos, rock, map)
          rock_pos = new_pos
        end
        i += 1

        new_pos = {rock_pos[0], rock_pos[1] - 1}
        if conflict(new_pos, rock, map)
          rock.each { |part|
            map[{rock_pos[0] + part[0], rock_pos[1] + part[1]}] = true
            max_height = Math.max(max_height, rock_pos[1] + part[1])
          }
          break
        else
          rock_pos = new_pos
        end
      end
    }

    p2 = 1554117647070 # Done manually. TODO - Automate
    return p1, p2
  end
end
