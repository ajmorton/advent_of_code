#! /usr/bin/env pypy3
from . import read_as
from .helpers import Grid, Tup
from heapq import *

U, R, D, L = 0, 1, 2, 3
DIRS = [Tup(-1,0), Tup(0,1), Tup(1,0), Tup(0,-1)] # U, R, D, L

def search(start_pos, end_pos, grid):
    seen = Grid([[[None for _ in DIRS] for _ in grid[0]] for _ in grid])

    to_explore = [(0, start_pos, R, [start_pos]), (1000, start_pos, D, [start_pos]), (1000, start_pos, U, [start_pos])]
    heapify(to_explore)

    best_dist = 999999999999999
    all_spots = set()

    while to_explore:
        cur_dist, cur_pos, cur_dir, cur_path = heappop(to_explore)

        if cur_dist > best_dist:
            continue

        if cur_pos == end_pos:
            if cur_dist < best_dist:
                best_dist = cur_dist
                all_spots = set(cur_path)
                all_spots.add(end_pos)
            elif cur_dist == best_dist:
                for spot in cur_path:
                    all_spots.add(spot)
        else:

            # Walk to end
            num_steps = 1
            interim_positions = []
            while True:
                to_insert = []

                next_pos = cur_pos + num_steps * DIRS[cur_dir]
                next_dist = cur_dist + num_steps
                next_dist_turn = next_dist + 1000
                interim_positions.append(next_pos)
                if grid[next_pos] != '#':
                    if grid[next_pos + DIRS[cur_dir]] == '#':
                        if seen[next_pos][cur_dir] and next_dist > seen[next_pos][cur_dir]:
                           pass
                        else:
                            seen[next_pos][cur_dir] = next_dist
                            new_path = cur_path + interim_positions
                            heappush(to_explore, (next_dist, next_pos, cur_dir, new_path))
                else: 
                    break

                for turn in [(cur_dir - 1) % 4, (cur_dir + 1) % 4]:
                    if grid[next_pos + DIRS[turn]] != '#':
                        if seen[next_pos][turn]:
                            if next_dist_turn <= seen[next_pos][turn]:
                                seen[next_pos][turn] = next_dist_turn
                                new_path = cur_path + interim_positions
                                heappush(to_explore, (next_dist_turn, next_pos, turn, new_path))
                        else:
                            seen[next_pos][turn] = next_dist_turn
                            new_path = cur_path + interim_positions
                            heappush(to_explore, (next_dist_turn, next_pos, turn, new_path))
    
                num_steps += 1

    return best_dist, len(all_spots)

def run() -> (int, int):
    grid = Grid(read_as.grid("input/day16.txt"))

    start_pos = grid.find2D('S')
    end_pos = grid.find2D('E')

    return search(start_pos, end_pos, grid)
