module Day16
  extend self

  alias Valve = String
  alias Valves = Hash(Valve, {flow: Int32, id: Int32, links: Array(Valve)})
  alias Distances = Hash({Int32, Int32}, Int32)
  alias Scores = Hash(Int64, Int32)

  def get_pairwise_dists(valves : Valves) : Distances
    dist = Distances.new(default_value: 1_000_000)

    # Init known links
    valves.each { |name, v|
      dist[{v[:id], v[:id]}] = 0
      v[:links].each { |link| dist[{v[:id], valves[link][:id]}] = 1 }
    }

    # Floyd-Warshall
    ids = valves.values.map(&.[:id])
    changes_made = true
    while changes_made
      changes_made = false
      ids.each { |i|
        ids.each { |j|
          ids.each { |k|
            if dist[{i, j}] > dist[{i, k}] + dist[{k, j}]
              changes_made = true
              dist[{i, j}] = dist[{i, k}] + dist[{k, j}]
            end
          }
        }
      }
    end

    return dist
  end

  # Find the best score for closing each combination of valves
  def populate_scores(cur_score : Int32, cur_pos : Int32, time_remaining : Int32, unopened : Int64, distance_to : Distances, flows : Array(Int32), scores : Scores, all_v : Int64)
    opened = all_v ^ unopened
    scores[opened] = cur_score if cur_score > scores[opened]

    # Open next valve
    (0..63).each { |id|
      new_pos = 1_i64 << id
      next if (unopened & new_pos) != new_pos

      new_time = time_remaining - distance_to[{cur_pos, id}] - 1
      next if new_time <= 0

      new_unopened = unopened ^ new_pos
      new_score = cur_score + flows[id] * new_time
      populate_scores(new_score, id, new_time, new_unopened, distance_to, flows, scores, all_v)
    }
  end

  def run(input_file : String)
    flows = [] of Int32
    valves = Valves.new
    File.read(input_file).lines.map_with_index { |line, i|
      regex = /Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/.match(line).not_nil!
      valves[regex[1]] = {flow: regex[2].to_i, id: i, links: regex[3].split(", ")}
      flows.push(regex[2].to_i)
    }

    distances = get_pairwise_dists(valves)
    unopened = valves.values.map { |v| v[:flow] > 0 ? 1_i64 << v[:id] : 0_i64 }.reduce { |l, r| l | r }

    # P1
    scores_p1 = Scores.new(default_value: 0)
    populate_scores(0, valves["AA"][:id], 30, unopened, distances, flows, scores_p1, unopened)
    p1 = scores_p1.values.max

    # P2
    scores_p2 = Scores.new(default_value: 0)
    populate_scores(0, valves["AA"][:id], 26, unopened, distances, flows, scores_p2, unopened)

    p2 = 0
    scores_p2_arr = scores_p2.to_a
    (0...scores_p2_arr.size).each { |i|
      (i + 1...scores_p2_arr.size).each { |j|
        hum_opened, hum_score = scores_p2_arr[i]
        ele_opened, ele_score = scores_p2_arr[j]
        if (hum_opened & ele_opened) == 0
          p2 = Math.max(p2, hum_score + ele_score)
        end
      }
    }

    return p1, p2
  end
end
