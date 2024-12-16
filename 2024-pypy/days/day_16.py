#! /usr/bin/env pypy3
from . import read_as

def search(start_pos, end_pos, gridd):
    seen = {}
    seen_combo = set()

    a_star = lambda pos: abs(abs(pos.real) - abs(end_pos.real)) + abs(abs(pos.imag) - abs(end_pos.imag))

    start_astar = a_star(start_pos)
    to_explore = [(start_pos, 1, 0, start_astar, [start_pos]), (start_pos, 1j, 1000, start_astar, [start_pos]), (start_pos, -1j, 1000,start_astar, [start_pos])]
    best_dist = 999999999999999

    all_spots = set()

    while to_explore:
        to_explore = sorted(to_explore, key=lambda x: (x[2] + x[3]))
        cur_pos, cur_dir, cur_dist, aa_ss, cur_path = to_explore[0]
        to_explore = to_explore[1:]

        if cur_dist > best_dist:
            continue

        # if (cur_pos, cur_dir) in seen:
        #     if cur_dist < seen[(cur_pos, cur_dir)]:
        #         seen[(cur_pos, cur_dir)] = cur_dist
        #     else:
        #         continue

        if cur_pos == end_pos:
            if cur_dist < best_dist:
                best_dist = cur_dist
                all_spots = set(cur_path)
                all_spots.add(end_pos)
            elif cur_dist == best_dist:
                for spot in cur_path:
                    all_spots.add(spot)
            else:
                return cur_dist, all_spots
        else:

            # Walk to end
            num_steps = 1
            interim_positions = []
            while True:
                next_pos = cur_pos + (num_steps *cur_dir)
                interim_positions.append(next_pos)
                if next_pos not in gridd:
                    if (next_pos + cur_dir) in gridd:
                        if (next_pos, cur_dir) in seen and cur_dist + num_steps > seen[(next_pos, cur_dir)]:
                           pass
                        else:
                            new_path = cur_path.copy()
                            new_path.extend(interim_positions)
                            to_explore.append((next_pos, cur_dir, cur_dist + num_steps, a_star(next_pos), new_path))
                else: 
                    break

                if not (next_pos + (cur_dir * 1j)) in gridd:
                    if (next_pos, cur_dir * 1j) in seen:
                        if cur_dist + num_steps + 1000 <= seen[(next_pos, cur_dir * 1j)]:
                            seen[(next_pos, cur_dir * 1j)] = cur_dist + num_steps + 1000
                            new_path = cur_path.copy()
                            new_path.extend(interim_positions)
                            to_explore.append((next_pos, cur_dir * 1j, cur_dist + num_steps + 1000, a_star(next_pos), new_path))
                    else:
                        seen[(next_pos, cur_dir * 1j)] = cur_dist + num_steps + 1000
                        new_path = cur_path.copy()
                        new_path.extend(interim_positions)
                        to_explore.append((next_pos, cur_dir * 1j, cur_dist + num_steps + 1000, a_star(next_pos), new_path))
    
                if not (next_pos + (cur_dir * -1j)) in gridd:
                    if (next_pos, cur_dir * -1j) in seen:
                        if cur_dist + num_steps + 1000 <= seen[(next_pos, cur_dir * -1j)]:
                            seen[(next_pos, cur_dir * -1j)] = cur_dist + num_steps + 1000
                            new_path = cur_path.copy()
                            new_path.extend(interim_positions)
                            to_explore.append((next_pos, cur_dir * -1j, cur_dist + num_steps + 1000, a_star(next_pos), new_path))
                    else:
                        seen[(next_pos, cur_dir * -1j)] = cur_dist + num_steps + 1000
                        new_path = cur_path.copy()
                        new_path.extend(interim_positions)
                        to_explore.append((next_pos, cur_dir * -1j, cur_dist + num_steps + 1000, a_star(next_pos), new_path))

                num_steps += 1
    return best_dist, all_spots

def run() -> (int, int):
    p1 = p2 = 0
    grid = read_as.grid("input/day16.txt")

    end_pos = start_pos = 0

    gridd = {}

    for r, row in enumerate(grid):
        for c, cell in enumerate(row):
            if cell == 'E':
                end_pos = (r*1j + c)
            elif cell == 'S':
                start_pos = (r*1j + c)
            elif cell == '#':
                gridd[r*1j + c] = True


    p1, p2 = search(start_pos, end_pos, gridd)
    return (p1, len(p2))