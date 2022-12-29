module Day19
  extend self

  TYPES = ["geode", "obsidian", "clay", "ore"]

  alias Cost = {Int32, Int32, Int32, Int32}
  alias Blueprint = {Cost, Cost, Cost, Cost}
  alias Minerals = {Int32, Int32, Int32, Int32}
  alias Robots = {Int32, Int32, Int32, Int32}
  alias State = {Int32, Minerals, Robots}

  # Wait enough time to gather resources _and_ build a bot. Return nil if not possible or not needed
  def wait_time(robot : Int32, cost : Cost, minerals : Minerals, robots : Robots, max_needed_robots : Robots) : Int32?
    if robot != 0 && max_needed_robots[robot] <= robots[robot]
      # No need for more of this robot. We can only assemble one bot per turn so mining additional resources offers no benefit
      return nil
    end

    can_build_eventually = (0..3).all? { |n| cost[n] == 0 || robots[n] > 0 }
    if can_build_eventually
      time_till_enough_resources = (0..3).map { |n|
        minerals[n] >= cost[n] ? 0.0 : ((cost[n] - minerals[n]) / robots[n]).ceil
      }.select { |n| !n.nan? }.max.to_i
      return time_till_enough_resources + 1
    end

    return nil
  end

  def best_geodes(blueprint : Blueprint, end_time : Int32)
    max_geodes = 0

    max_needed_robots = {0, 1, 2, 3}.map { |m| blueprint.map(&.[m]).max }

    to_explore = Deque(State).new
    to_explore.push({0, {0, 0, 0, 0}, {0, 0, 0, 1}})
    explored = Set(State).new

    while !to_explore.empty?
      state = to_explore.pop
      time, minerals, robots = state

      # Assume if there are no obsidian robots it'll take at least 1 turn to buy a geode, if there are
      # no clay at least 2 turns etc. From then on assume a geode can be bought every turn.
      delay = robots[1] != 0 ? 1 : robots[2] != 0 ? 2 : 3
      best_possible_from_state = minerals[0] + robots[0]*(end_time - time) + (0..(end_time - time - delay)).sum

      # Can't improve. Give up on this branch
      next if best_possible_from_state <= max_geodes

      # Try waiting until we can build each bot
      (0..3).each { |m|
        cost = blueprint[m]
        if wait_time = wait_time(m, cost, minerals, robots, max_needed_robots)
          # No time to build this robot. Continue
          next if (time + wait_time) > end_time

          # Wait for enough minerals
          new_time = time + wait_time
          new_minerals = minerals.map_with_index { |mineral, i| mineral + (robots[i] * wait_time) }

          # Pay cost of new bot and add it
          new_minerals = new_minerals.map_with_index { |min, i| min - cost[i] }
          new_robots = robots.map_with_index { |r, i| i == m ? r + 1 : r }

          new_state = {new_time, new_minerals, new_robots}

          if explored.add?(new_state)
            to_explore.push(new_state)
          end
        end
      }

      # Else try wait to the end
      wait_time = end_time - time
      new_minerals = minerals.map_with_index { |mineral, i| mineral + (robots[i] * wait_time) }
      max_geodes = Math.max(max_geodes, new_minerals[0])
    end

    return max_geodes
  end

  def run(input_file : String)
    regex = /Blueprint \d+: Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./

    blueprints = File.read(input_file).lines.map { |line|
      r = regex.match(line).not_nil!
      ore_cost = {0, 0, 0, r[1].to_i}
      clay_cost = {0, 0, 0, r[2].to_i}
      obsidian_cost = {0, 0, r[4].to_i, r[3].to_i}
      geode_cost = {0, r[6].to_i, 0, r[5].to_i}
      {geode_cost, obsidian_cost, clay_cost, ore_cost}
    }

    p1 = blueprints.map_with_index { |bp, i| best_geodes(bp, 24) * (i + 1) }.sum
    p2 = blueprints.first(3).map { |bp| best_geodes(bp, 32) }.product
    return p1, p2
  end
end
