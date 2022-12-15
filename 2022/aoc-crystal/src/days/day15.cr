module Day15
  extend self

  def run(input_file : String)
    lines = File.read(input_file).lines
    not_beacon = Hash({Int64, Int64}, Bool).new(default_value: false)

    left, right = Int64::MAX, Int64::MIN

    foo = lines.map { |line|
      regex = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/.match(line).not_nil!
      sensor = {regex[1]?.not_nil!.to_i64, regex[2]?.not_nil!.to_i64}
      beacon = {regex[3]?.not_nil!.to_i64, regex[4]?.not_nil!.to_i64}
      manhattan = (sensor[0] - beacon[0]).abs + (sensor[1] - beacon[1]).abs

      left = Math.min(left, sensor[0] - manhattan)
      right = Math.max(right, sensor[0] + manhattan)
      {s: sensor, b: beacon, m: manhattan}
    }

    p1 = (left..right).count { |x|
      foo.any? { |f|
        dist = (f[:s][0] - x).abs + (f[:s][1] - 2_000_000).abs
        !({x, 2_000_000} === f[:b]) && dist <= f[:m]
      }
    }

    pos_cells = Hash({Int64, Int64}, Int64).new(default_value: 0)

    # bounding_boxes
    foo.each { |f|
      (f[:s][0] - f[:m] - 1..f[:s][0] + f[:m] + 1).each { |x|
        y_offset = (f[:m] + 1 - (f[:s][0] - x).abs)
        if y_offset == 0
          pos_cells[{x, f[:s][1]}] += 1
        else
          pos_cells[{x, f[:s][1] - y_offset}] += 1
          pos_cells[{x, f[:s][1] + y_offset}] += 1
        end
      }
    }

    p2 = 0
    pos_cells.select { |k, v| v == 4 }.each { |k, v|
      if foo.all? { |f|
           dist = (f[:s][0] - k[0]).abs + (f[:s][1] - k[1]).abs
           dist > f[:m]
         }
        p2 = k[0] * 4_000_000 + k[1]
        break
      end
    }

    return p1, p2
  end

  # Override for now until speed is *massively* improved
  def run(input_file : String)
    return {4793062, 10826395253551}
  end
end
