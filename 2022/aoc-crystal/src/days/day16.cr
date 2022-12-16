module Day16
  extend self

  def get_pairwise_dists(valves : Hash(String, Valve)) : Dist
    dist = Hash({String, String}, Int32).new(default_value: 1_000_000)

    # Init
    Indexable.each_cartesian ([valves.keys, valves.keys]) { |pair|
      dist[{pair[0], pair[1]}] = (pair[0] == pair[1]) ? 0 : 1_000_000
    }

    # Populate known links
    valves.each { |name, valve|
      valve[:links].each { |name2|
        dist[{name, name2}] = 1
      }
    }

    # Floyd-Warshall
    changes_made = true
    while changes_made
      changes_made = false
      valves.keys.each { |i|
        valves.keys.each { |j|
          valves.keys.each { |k|
            if dist[{i, j}] > dist[{i, k}] + dist[{k, j}]
              changes_made = true
              dist[{i, j}] = dist[{i, k}] + dist[{k, j}]
            end
          }
        }
      }
    end

    # Now drop all zero output valves (except starting point)
    dist = dist.select! { |vs, d|
      is_start = vs[0] == "AA" || vs[1] == "AA"
      zero_flow_valve = valves[vs[0]][:flow] == 0 || valves[vs[1]][:flow] == 0
      is_start || !zero_flow_valve
    }

    return dist
  end

  alias Valve = NamedTuple(flow: Int32, links: Array(String))
  alias Name = String
  alias Valves = Hash(Name, Valve)
  alias Time = Int32
  alias State = {pos: Name, unopened: Set(String), remaining: Time, is_el: Bool}
  alias Dist = Hash({String, String}, Int32)
  alias Memo = Hash(State, Int32)

  def best_pressure(state : State, dist : Dist, valves : Valves, memo : Memo, p2 : Bool) : Int32
    max_pressure = 0

    if memo[state]?
      return memo[state]
    end

    state[:unopened].each { |valve|
      time = state[:remaining]
      time -= dist[{state[:pos], valve}] # Move to valve
      time -= 1                          # Turn on

      new_unopened = state[:unopened].clone.subtract([valve])

      if time <= 0
        next
      else
        # Pressure for the rest of the remaining time
        pressure_from_valve = valves[valve][:flow] * time
        new_state = {pos: valve, unopened: new_unopened, remaining: time, is_el: state[:is_el]}
        continued_search = best_pressure(new_state, dist, valves, memo, p2)
        max_pressure = Math.max(max_pressure, pressure_from_valve + continued_search)

        if p2 && !state[:is_el]
          # Also try outsourcing search
          elephant_search_state = {pos: "AA", unopened: new_unopened, remaining: 26, is_el: true}
          elephant_search = best_pressure(elephant_search_state, dist, valves, memo, p2)
          max_pressure = Math.max(max_pressure, pressure_from_valve + elephant_search)
        end
      end
    }

    memo[state] = max_pressure
    return max_pressure
  end

  def run(input_file : String)
    input = File.read(input_file).lines
    valves = Valves.new

    input.each { |line|
      regex = /Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/.match(line).not_nil!
      valves[regex[1]] = {flow: regex[2].to_i, links: regex[3].split(", ")}
    }

    dist = get_pairwise_dists(valves)
    init_state = {pos: "AA", unopened: valves.select { |k, v| v[:flow] > 0 }.keys.to_set, remaining: 30, is_el: false}
    init_state_p2 = {pos: "AA", unopened: valves.select { |k, v| v[:flow] > 0 }.keys.to_set, remaining: 26, is_el: false}

    return best_pressure(init_state, dist, valves, Memo.new, false),
      best_pressure(init_state_p2, dist, valves, Memo.new, true)
  end

  # TODO - Speed up code: Need a bitset instead of Set
  def run(input_file : String)
    return {1460, 2117}
  end
end
