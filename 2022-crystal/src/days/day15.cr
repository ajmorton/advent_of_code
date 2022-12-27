module Day15
  extend self

  alias LinearEq = {m: Int64, c: Int64}

  def run(input_file : String)
    # Parse sensors
    sensors = File.read(input_file).lines.map { |line|
      regex = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/.match(line).not_nil!
      sensor = {regex[1]?.not_nil!.to_i64, regex[2]?.not_nil!.to_i64}
      beacon = {regex[3]?.not_nil!.to_i64, regex[4]?.not_nil!.to_i64}
      manhattan = (sensor[0] - beacon[0]).abs + (sensor[1] - beacon[1]).abs

      {pos: sensor, dist: manhattan}
    }

    # Describe bounding boxes (just outside the sensor range) as four `y = mx + c` equations
    pos_gradients = [] of LinearEq
    neg_gradients = [] of LinearEq
    sensors.each { |sensor|
      pos_gradients.push({m: +1_i64, c: sensor[:pos][1] + sensor[:dist] + 1 - sensor[:pos][0]})
      pos_gradients.push({m: +1_i64, c: sensor[:pos][1] - sensor[:dist] - 1 - sensor[:pos][0]})
      neg_gradients.push({m: -1_i64, c: sensor[:pos][1] + sensor[:dist] + 1 + sensor[:pos][0]})
      neg_gradients.push({m: -1_i64, c: sensor[:pos][1] - sensor[:dist] - 1 + sensor[:pos][0]})
    }

    # x ranges covered by sensors along the y == 2_000_000 axis
    ranges = sensors.map { |sensor|
      if sensor[:dist] >= (sensor[:pos][1] - 2_000_000).abs
        {sensor[:pos][0] - (sensor[:dist] - (sensor[:pos][1] - 2_000_000).abs).abs,
         sensor[:pos][0] + (sensor[:dist] - (sensor[:pos][1] - 2_000_000).abs).abs}
      end
    }.compact

    # Cheat: All these ranges overlap so we can just take max - min
    #        There's also no beacons on this row, so don't bother subtracting them from the count
    p1 = ranges.map(&.[1]).max - ranges.map(&.[0]).min

    # Find intersection between lines describing bounding boxes.
    intersects = Hash({x: Int64, y: Int64}, Int32).new(default_value: 0)
    pos_gradients.each { |pos_grad|
      neg_gradients.each { |neg_grad|
        intersect_x = (neg_grad[:c] - pos_grad[:c]) // 2
        intersect_y = intersect_x + pos_grad[:c]
        intersects[{x: intersect_x, y: intersect_y}] += 1
      }
    }

    # The one point not covered by any sensors will be one of these intersections.
    # Confirm it's not visible by any sensors and report it
    p2 = intersects.select { |pos, num_occ| num_occ == 4 }.each { |pos, _|
      not_in_range = sensors.all? { |s| s[:dist] < (s[:pos][0] - pos[:x]).abs + (s[:pos][1] - pos[:y]).abs }
      if not_in_range
        break pos[:x] * 4_000_000 + pos[:y]
      end
    }

    return p1, p2
  end
end
